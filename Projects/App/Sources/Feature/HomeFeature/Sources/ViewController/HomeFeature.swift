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
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var containerView = UIView()
    
    private lazy var contentView = UIView()
    
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
        colView.isScrollEnabled = false
        colView.register(MYRPlansCVC.self)
        return colView
    }()
    
    private lazy var emptyView = MYREmptyView()
    
    private lazy var createPlansButton: MYRIconButton = {
        let button = MYRIconButton(image: .Moyeora.plus,cornerRadius: MYRConstants.cornerRadiusMedium)
        return button
    }()

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateScrollViewContentSize()
    }
    
    public override func configureAttributes() {
        let view = MYRNavigationView(title: "약속 일정")
        self.setNavigationBar(isBackButton: true, titleView: view, rightButtonItem: nil)
        self.dataSource = self.generateDataSource()
        self.emptyView.type = .home
        self.emptyView.isHidden = true
    }
   
    public override func configureUI() {
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.createPlansButton)
        self.scrollView.addSubview(self.containerView)
        
        [self.calendarView,
         self.listLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        [self.contentView,
         self.plansCollectionView,
         self.emptyView
         ].forEach {
            self.containerView.addSubview($0)
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(432 + 8 + 20 + 24)
        }
        
        self.containerView.snp.makeConstraints { make in
            make.top.bottom.width.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(545)
        }
        
        self.calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.calendarTopMargin)
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
            make.top.equalTo(self.contentView.snp.bottom).offset(Metric.collViewTopPadding)
            make.leading.equalTo(self.calendarView.snp.leading)
            make.trailing.equalTo(self.calendarView.snp.trailing)
            make.height.greaterThanOrEqualTo(300)
            make.bottom.equalToSuperview()
        }
        
        self.emptyView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.bottom).offset(Metric.collViewTopPadding)
            make.leading.equalTo(self.calendarView.snp.leading)
            make.trailing.equalTo(self.calendarView.snp.trailing)
            make.height.greaterThanOrEqualTo(126)
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
        
        output.plansArrInDate.drive(with: self) { owner, plansArr in
            owner.emptyView.bindEmptyView(isEmpty: plansArr.isEmpty)
            
            let snap = owner.setSnapshot(plans: plansArr)
            owner.dataSource?.apply(snap)
            owner.updateScrollViewContentSize()
            owner.plansCollectionView.reloadData()
        }
        .disposed(by: self.disposeBag)
        
        output.plansArrIHad
            .map({ $0.map { $0.date } })
            .drive(with: self, onNext: { owner, dates in
                owner.calendarView.bindCalendarView(plans: dates)
            })
            .disposed(by: self.disposeBag)
    }
}

private extension HomeFeature {
    func updateScrollViewContentSize() {
        let collectionViewHeight = self.plansCollectionView.contentSize.height
        let contentViewHeight = self.contentView.frame.height
        // 24는 label과 plansCollectionView 패딩, 8은 calendarView 위 여백
        let totalHeight = collectionViewHeight + contentViewHeight
        + 24 + 8
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: totalHeight)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: totalHeight)
        
    }
    
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
                                              heightDimension: .estimated(CGFloat(Metric.cellHeight)))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(CGFloat(Metric.cellHeight)))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(Metric.cellContentPadding)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
