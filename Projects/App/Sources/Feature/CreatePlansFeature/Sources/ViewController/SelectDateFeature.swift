//
//  SelectDateFeature.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//
import UIKit
import SnapKit
import RxSwift

public final class SelectDateFeature: BaseFeature {
    public let viewModel: SelectDateViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Date>?
    
    let titleView = MYRNavigationView(title: "약속 날짜")
    
    private lazy var label = MYRLabel("원하시는 날짜와 시간을\n입력해주세요.", textColor: .neutral(.balck), font: .h2)
    
    private lazy var calendarView = MYRCalendarView(feature: .ceate)
    
    private lazy var timeLabel = MYRLabel("약속 시간", textColor: .neutral(.balck), font: .h2)
    
    private lazy var timeCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        view.register(TimeCVC.self)
        view.allowsMultipleSelection = false
        view.delegate = self
        return view
    }()
    
    private lazy var doneButton = MYRTextButton("선택 완료", textColor: .neutral(.balck), font: .subtitle2, backgroundColor: .primary(.primary2), cornerRadius: 16)
    
    public init(viewModel: SelectDateViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public override func configureAttributes() {
        self.label.numberOfLines = 0
        self.dataSource = self.generateDataSource()
        self.setNavigationBar(isBackButton: true, titleView: self.titleView, rightButtonItem: nil, isSetTitleViewOnCenter: true)
        self.view.backgroundColor = .white
    }
    
    public override func configureUI() {
        [self.label, self.calendarView,
         self.timeLabel, self.timeCollectionView,
         self.doneButton]
            .forEach { self.view.addSubview($0) }
        
        self.label.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(28)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.label.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(400)
        }
        
        self.timeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.timeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.timeLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(200)
        }
        
        self.doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    public override func bindViewModel() {
        let selectedTime = self.timeCollectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { owner, indexPath in
                owner.dataSource?.itemIdentifier(for: indexPath)
            }
            .asObservable()
        
        let selectedDate = self.calendarView.selectedDate.asObservable()
        
        let input = SelectDateViewModel.Input(
            calendarDateDidTap: selectedDate,
            selectedDate: selectedTime,
            doneButtonDidTap: self.doneButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.trnasform(input: input)
        
        output.times.drive(with: self) { owner, times in
            let snapshot = owner.setSnapshot(times: times)
            owner.dataSource?.apply(snapshot)
        }
        .disposed(by: self.disposeBag)
        
        output.isEnabledButton
            .drive(with: self) { owner, isEnabled in
                owner.doneButton.isEnabled = isEnabled
            }
            .disposed(by: self.disposeBag)
    }
    
}


extension SelectDateFeature: UICollectionViewDelegate {
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
                    widthDimension: .fractionalWidth(1 / 6),
                    heightDimension: .fractionalWidth(1 / 11)
                ),
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.orthogonalScrollingBehavior = .continuous

            return section
        }
    }
    
    func generateDataSource() -> UICollectionViewDiffableDataSource<Int, Date> {
        return UICollectionViewDiffableDataSource<Int, Date>(collectionView: self.timeCollectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueCell(TimeCVC.self, for: indexPath) else { return UICollectionViewCell() }
            cell.bindCell(with: item)
            return cell
            
        }
    }
    
    func setSnapshot(times: [Date]) -> NSDiffableDataSourceSnapshot<Int, Date> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Date>()
        snapshot.appendSections([0])
        snapshot.appendItems(times)
        return snapshot
    }
}
