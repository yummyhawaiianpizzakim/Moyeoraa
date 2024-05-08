//
//  LocationShareFeature.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/3/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SnapKit
import RxSwift
import RxCocoa

public final class LocationShareFeature: BaseFeature {
    public let viewModel: LocationShareViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, User>?
    
    private lazy var naviTitleView = MYRNavigationView(title: "")
    
    private lazy var mapAnnotationView = MYRAnnotationView()
    
    private var userAnnotationViews: [String: UserAnnotationView] = [:]
    
    private lazy var locationManager = CLLocationManager()
    
    private lazy var mapView: MYRMapView = {
        let view = MYRMapView(frame: .zero)
        view.register(MYRAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MYRAnnotationView")
        view.register(UserAnnotationView.self, forAnnotationViewWithReuseIdentifier: "UserAnnotationView")
        view.addAnnotation(self.mapAnnotationView)
        return view
    }()
    
    private lazy var memberCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        view.register(MYRMapUserCVC.self)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        return view
    }()
    
    private lazy var plansLocationButton = MYRIconButton(image: .Moyeora.pin, backgroundColor: .neutral(.white), cornerRadius: 8)
    
    public init(viewModel: LocationShareViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewModel.endLocationShare()
        self.locationManager.stopUpdatingLocation()
    }
    
    public override func configureAttributes() {
        self.mapView.delegate = self
        self.setNavigationBar(isBackButton: true, titleView: self.naviTitleView, rightButtonItem: nil)
        self.naviTitleView.backgroundColor = .clear
        self.dataSource = self.generateDataSource()
        self.locationManager.startUpdatingLocation()
    }
    
    public override func configureUI() {
        [self.mapView,
         self.memberCollectionView,
         self.plansLocationButton
        ].forEach { self.view.addSubview($0) }
        
        self.mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.memberCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(126)
        }
        
        self.plansLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.height.width.equalTo(48)
            make.bottom.equalTo(self.memberCollectionView.snp.top).offset(-8)
        }
    }
    
    public override func bindViewModel() {
        let myCoordinate = self.locationManager.rx.didUpdateLocations
            .compactMap({ $0.last })
            .map({ Coordinate(lat: $0.coordinate.latitude, lng: $0.coordinate.longitude) })
            .share()
        
        let isArrived = myCoordinate
            .withUnretained(self)
            .map { owner, _ in
            owner.isArrivedAtPlans()
            }
        
        let input = LocationShareViewModel.Input(
            myCoordinate: myCoordinate,
            isArrived: isArrived
        )
        
        let output = self.viewModel.trnasform(input: input)
        
        output.title.drive(with: self) { owner, title in
            owner.naviTitleView.setText(title)
        }
        .disposed(by: self.disposeBag)
        
        output.members.drive(with: self) { owner, users in
            let snapshot = owner.setSnapshot(users: users)
            owner.dataSource?.apply(snapshot)
        }
        .disposed(by: self.disposeBag)
        
        output.mapCoordinate.drive(with: self) { owner, coordinate in
            owner.setPlansLocation(coordinate)
            owner.setMapAnnotation(to: coordinate)
        }
        .disposed(by: self.disposeBag)
        
        self.plansLocationButton.rx.tap
            .withLatestFrom(output.mapCoordinate)
            .asDriver(onErrorDriveWith: Driver<Coordinate>.empty())
            .drive(with: self) { owner, coordinate in
                owner.setPlansLocation(coordinate)
            }
            .disposed(by: self.disposeBag)
        
        output.sharedLocations
            .drive(with: self) { owner, sharedLocations in
                sharedLocations.forEach { sharedLocation in
                    guard let annotation = owner.userAnnotationViews[sharedLocation.userID]
                    else { return }
                    owner.updateAnnotation(annotation: annotation, lat: sharedLocation.latitude, lng: sharedLocation.longitude)
                    owner.bindCellIsArrived(userID: sharedLocation.userID, isArrived: sharedLocation.isArrived)
                }
            }
            .disposed(by: self.disposeBag)
        
        output.userAnnotations
            .drive(with: self) { owner, userAnnotations in
                owner.setUserAnnotations(userAnnotations)
            }
            .disposed(by: self.disposeBag)
    }
}

private extension LocationShareFeature {
    func createLayout() -> UICollectionViewLayout {
        let groupWidthDimension: CGFloat = 94/375
        let minumumZoomScale: CGFloat = 73/94
        let maximumZoomScale: CGFloat = 1.0
        let inset = (self.view.frame.width - self.view.frame.width * groupWidthDimension) / 2
        let section = self.makeCarouselSection(groupWidthDimension: groupWidthDimension)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: inset,
                                                        bottom: 0,
                                                        trailing: inset)
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            let containerWidth = environment.container.contentSize.width
            items.forEach { [weak self] item in
                let distanceFromCenter = abs((item.center.x - offset.x) - environment.container.contentSize.width / 2.0)
                let scale = max(maximumZoomScale - (distanceFromCenter / containerWidth), minumumZoomScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                if scale >= maximumZoomScale * 0.9 {
                    self?.selectAnnotation(at: item.indexPath)
                    print("self?.selectAnnotation(at:::: \(item.indexPath)")
                }
            }
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func makeCarouselSection(groupWidthDimension: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidthDimension),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
    
    func generateDataSource() -> UICollectionViewDiffableDataSource<Int, User> {
        return UICollectionViewDiffableDataSource<Int, User>(collectionView: self.memberCollectionView) { [weak self] collectionView, indexPath, item in
            guard let self,
                let cell = collectionView.dequeueCell(MYRMapUserCVC.self, for: indexPath)
            else { return UICollectionViewCell() }
            
            cell.bindCell(profileURL: item.profileImage ?? "", userName: item.name)
            
            return cell
        }
    }
    
    func setSnapshot(users: [User]) -> NSDiffableDataSourceSnapshot<Int, User> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(users)
        return snapshot
    }
    
    func bindCellIsArrived(userID: String, isArrived: Bool) {
        let snapshot = self.dataSource?.snapshot()
        guard let user = snapshot?.itemIdentifiers.filter({ user in
            user.id == userID
        }).last else { return }
        guard let section = snapshot?.sectionIdentifier(containingItem: user),
              let itemIndex = snapshot?.indexOfItem(user),
              let sectionIndex = snapshot?.indexOfSection(section)
        else { return }
        let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
        guard let cell = self.memberCollectionView.cellForItem(at: indexPath) as? MYRMapUserCVC
        else { return }
        
        cell.bindIsArrived(isArrived)
    }
}

extension LocationShareFeature: MKMapViewDelegate {
    private func setPlansLocation(_ coordinate: Coordinate, animated: Bool = true) {
        let coordinate2D = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lng)
        guard !(coordinate2D.latitude == .zero) else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate2D, span: span)
        
        self.mapView.setRegion(region, animated: animated)
    }
    
    private func setMapAnnotation(to coordinate: Coordinate) {
        self.mapAnnotationView.coordinate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lng)
    }
    
    private func setUserAnnotations(_ annotations: [String: UserAnnotationView]) {
        self.userAnnotationViews = annotations
        for (_, annotation) in annotations {
            self.mapView.addAnnotation(annotation)
        }
    }
    
    private func updateAnnotation(annotation: UserAnnotationView, lat: Double, lng: Double) {
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    func selectAnnotation(at indexPath: IndexPath) {
        
        guard let focusedUser = self.dataSource?.itemIdentifier(for: indexPath),
              let focusedAnnotation = self.userAnnotationViews[focusedUser.id]
        else { return }
        self.mapView.deselectAnnotation(focusedAnnotation, animated: true)
        self.mapView.selectAnnotation(focusedAnnotation, animated: true)
        print("selectAnnotation::")
    }
    
    
    func isArrivedAtPlans() -> Bool {
        guard let currentLocation = self.locationManager.location else { return false }
        
        let distance = currentLocation.distance(from: .init(latitude: self.mapAnnotationView.coordinate.latitude, longitude: self.mapAnnotationView.coordinate.longitude))
        
        return distance <= 100.0 ? true : false
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is UserAnnotationView:
            guard let annotationView =  mapView.dequeueReusableAnnotationView(withIdentifier: "UserAnnotationView", for: annotation) as? UserAnnotationView,
                  let annotation = annotation as? UserAnnotationView
            else { return nil }
            annotationView.setImage(imageURLString: annotation.userImageURLString ?? "")
            return annotationView
        case is MYRAnnotationView:
            guard let annotationView =  mapView.dequeueReusableAnnotationView(withIdentifier: "MYRAnnotationView", for: annotation) as? MYRAnnotationView
            else { return nil }
            annotationView.image = .Moyeora.pin
            return annotationView
        default:
            return nil
        }
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? UserAnnotationView
        else { return }
        
        mapView.setCenter(annotation.coordinate, animated: true)
    }
}
