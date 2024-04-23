//
//  HomeFeature.swift
//  HomeFeatureInterface
//
//  Created by 김요한 on 2024/03/27.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

public final class HomeFeature: BaseFeature {
    private enum Metric {
        static let calendarTopMargin = 8
        static let calendarBottomMargin = -16
        static let calendarLeadingMargin = 16
        static let calendarTrailingMargin = -calendarLeadingMargin
        static let calendarViewHeight = 432
        static let listLabelTopPadding = 20
        static let listLabelLeadingPadding = 4
        static let listLabelTrailingPadding = -listLabelLeadingPadding
        static let collViewTopPadding = 12
        static let cellContentPadding = 16
        static let cellHeight = 106
        static let plusButtonTrailingMargin = -16
        static let plusButtonBottomMargin = -16
        static let plusButtonWidth = 48
    }
    public let viewModel: HomeViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Plans>?
    
    private lazy var calendarView: MYRCalendarView = {
        let view = MYRCalendarView(feature: .home)
        return view
    }()
    
    private lazy var listLabel: MYRLabel = {
        let label = MYRLabel("목록", font: .h1)
        return label
    }()
    
    private lazy var plansCollectionView: UICollectionView = {
        let colView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        colView.register(MYRPlansCVC.self)
        return colView
    }()
    
    private lazy var createPlansButton: MYRIconButton = {
        let button = MYRIconButton(image: .Moyeora.plus,cornerRadius: MYRConstants.cornerRadiusMedium)
        return button
    }()

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func configureAttributes() {
        let view = MYRNavigationView(title: "약속 일정")
        self.setNavigationBar(isBackButton: true, titleView: view, rightButtonItem: nil)
    }
    
    public override func configureUI() {
        [self.calendarView,
         self.listLabel,
         self.plansCollectionView,
         self.createPlansButton].forEach {
            self.view.addSubview($0)
        }
        
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.calendarTopMargin)
            make.leading.equalToSuperview().offset(Metric.calendarLeadingMargin)
            make.trailing.equalToSuperview().offset(Metric.calendarTrailingMargin)
            make.height.equalTo(Metric.calendarViewHeight)
        }
        
        self.listLabel.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom).offset(Metric.listLabelTopPadding)
            make.leading.equalTo(self.calendarView.snp.leading).offset(Metric.listLabelLeadingPadding)
            make.trailing.equalTo(self.calendarView.snp.trailing).offset(Metric.listLabelTrailingPadding)
        }
        
        self.plansCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.listLabel.snp.bottom).offset(Metric.collViewTopPadding)
            make.leading.equalTo(self.calendarView.snp.leading)
            make.trailing.equalTo(self.calendarView.snp.trailing)
            make.bottom.equalToSuperview()
        }
        
        self.createPlansButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(Metric.plusButtonTrailingMargin)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.plusButtonBottomMargin)
            make.width.height.equalTo(Metric.plusButtonWidth)
        }
    }
    
    public override func bindViewModel() {
        
        let selectedItem = self.plansCollectionView.rx.itemSelected.withUnretained(self).compactMap { owner, indexPath in
            return owner.dataSource?.itemIdentifier(for: indexPath)
        }.asObservable()
        
        let input = HomeViewModel.Input(
            viewDidAppear: self.rx.viewDidAppear.map { _ in () }.asObservable(),
            calendarViewSelectedDate: self.calendarView.selectedDate.asObservable(),
            plansDidSelect: selectedItem,
            plusButtonDidTap: self.createPlansButton.rx.tap.map({ _ in }).asObservable()
        )
        let output = self.viewModel.trnasform(input: input)
        
        
        output.Plans.drive(with: self) { owner, plansArr in
            owner.dataSource = owner.generateDataSource()
            let snap = owner.setSnapshot(plans: plansArr)
            owner.dataSource?.apply(snap)
        }
        .disposed(by: self.disposeBag)
    }
}

private extension HomeFeature {
    func generateDataSource() -> UICollectionViewDiffableDataSource<Int, Plans> {
        let dataSource = UICollectionViewDiffableDataSource<Int, Plans>(collectionView: self.plansCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueCell(MYRPlansCVC.self, for: indexPath)
            else { return UICollectionViewCell() }
            cell.bindCell(title: item.title, location: item.location, time: item.date, countUser: item.usersID.count)
            
            return cell
        })
        
        return dataSource
    }

    func setSnapshot(plans: [Plans]) -> NSDiffableDataSourceSnapshot<Int, Plans> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Plans>()
        snapshot.appendSections([0])
        snapshot.appendItems(plans)
        return snapshot
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(CGFloat(Metric.cellHeight)))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(Metric.cellContentPadding)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
