//
//  PlansDetailFeature.swift
//  PlansDetailFeatureInterface
//
//  Created by 김요한 on 2024/04/11.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class PlansDetailFeature: BaseFeature {
    public let viewModel: PlansDetailViewModel
    
    private let deletePlansTrigger = PublishRelay<Void>()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, User>?
    
    private lazy var naviTitleView = MYRNavigationView(title: "")
    
    private lazy var menuButton = UIBarButtonItem(title: nil, image: .Moyeora.menu, target: nil, action: nil, menu: self.createUIMenu())
    
    private lazy var labelStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()
    
    private lazy var titleLabel = MYRLabel("", textColor: .neutral(.balck), font: .subtitle1)
    
    private lazy var locationLabel = MYRLabel("", textColor: .neutral(.balck), font: .body1)
    
    private lazy var dateLabel = MYRLabel("", textColor: .neutral(.balck), font: .body1)
    
    private lazy var memberLabel = MYRLabel("", textColor: .neutral(.balck), font: .body1)
    
    private lazy var mapView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()
    
    private lazy var headerLabel = MYRLabel("참여 중인 사람", textColor: .neutral(.balck), font: .subtitle1)
    
    private lazy var memberCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        view.register(MYRPlansDetailUserCVC.self)
        return view
    }()
    
    private lazy var enterChatButton = MYRTextButton("채팅방으로 이동", textColor: .neutral(.balck), font: .subtitle1, backgroundColor: .primary(.primary2), cornerRadius: 16)
    
    public init(viewModel: PlansDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func configureAttributes() {
        self.setNavigationBar(isBackButton: true, titleView: self.naviTitleView, rightButtonItem: self.menuButton)
        self.dataSource = self.generateDataSource()
    }
    
    public override func configureUI() {
        [self.labelStackView, self.mapView,
         self.headerLabel, self.memberCollectionView,
         self.enterChatButton]
            .forEach { self.view.addSubview($0) }
        
        [self.titleLabel, self.locationLabel, self.dateLabel, self.memberLabel]
            .forEach { self.labelStackView.addArrangedSubview($0) }
        
        self.labelStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(56)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.mapView.snp.makeConstraints { make in
            make.top.equalTo(self.labelStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(256)
        }
        
        self.headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.memberCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.headerLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.enterChatButton.snp.top).offset(-40)
            make.height.equalTo(99)
        }
        
        self.enterChatButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
        }
    }
    
    public override func bindViewModel() {
        let input = PlansDetailViewModel.Input(
            enterChatButton: self.enterChatButton.rx.tap.asObservable(),
            deleteTrigger: self.deletePlansTrigger.asObservable()
        )
        
        let output = self.viewModel.trnasform(input: input)
        
        output.title.drive(with: self) { owner, title in
            owner.titleLabel.setText(with: title)
            owner.naviTitleView.setText(title)
        }
        .disposed(by: self.disposeBag)
        
        output.address.drive(with: self) { owner, address in
            owner.locationLabel.setText(with: address)
        }
        .disposed(by: self.disposeBag)
        
        output.date.drive(with: self) { owner, date in
            let dateString = date.toStringWithCustomFormat(.yearToMinute)
            owner.dateLabel.setText(with: dateString)
        }
        .disposed(by: self.disposeBag)
        
        output.memberCount.drive(with: self) { owner, count in
            let countString = String(count)
            owner.memberLabel
                .setText(with: "\(countString)명 참여")
        }
        .disposed(by: self.disposeBag)
        
        output.dataSource.drive(with: self) { owner, users in
            let snapshot = owner.setSnapshot(users: users)
            owner.dataSource?.apply(snapshot)
        }
        .disposed(by: self.disposeBag)
        
        output.result
            .subscribe(with: self) { owner, _ in
                print("success")
                owner.viewModel.actions?.finishPlansDetailFeature()
            } onError: { owner, error in
                print("\(error)")
                let toastView = MYRToastView(type: .failure, message: "약속 삭제가 실패했습니다. 나중에 다시 시도해 주세요.", followsUndockedKeyboard: true)
                toastView.show(in: self.view)
            }
            .disposed(by: self.disposeBag)
    }
}

private extension PlansDetailFeature {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .absolute(88),
                    heightDimension: .absolute(99)
                ),
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.orthogonalScrollingBehavior = .continuous

            return section
        }
    }
    
    func generateDataSource() -> UICollectionViewDiffableDataSource<Int, User> {
        return UICollectionViewDiffableDataSource<Int, User>(collectionView: self.memberCollectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueCell(MYRPlansDetailUserCVC.self, for: indexPath)
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
}

private extension PlansDetailFeature {
    func createUIMenu() -> UIMenu {
        return UIMenu(
            title: "",
            options: [.destructive],
            children: self.createMenuItems()
        )
    }
    
    func createMenuItems() -> [UIAction] {
        return [
            UIAction(
                title: "수정하기",
                handler: { [weak self] _ in
                    self?.viewModel.showModifyPlansFeature()
                }
            ),
            UIAction(
                title: "삭제하기",
                attributes: [.destructive],
                handler: { [weak self] _ in
                    self?.showDeleteAlert()
                })
        ]
    }
    
    func showDeleteAlert() {
        let alert = MYRAlertController(
            title: "약속 삭제하기",
            message: "정말 삭제하시겠습니까?\n 삭제하시면 복구가 불가능합니다",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let logout = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            self?.deletePlansTrigger.accept(())
        }
        
        alert.addActions([cancel, logout])
        
        present(alert, animated: true, completion: nil)
    }
}
