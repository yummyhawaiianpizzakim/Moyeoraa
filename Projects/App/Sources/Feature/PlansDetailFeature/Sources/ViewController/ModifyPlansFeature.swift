//
//  ModifyPlansFeature.swift
//  PlansDetailFeature
//
//  Created by 김요한 on 2024/04/11.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

public final class ModifyPlansFeature: BaseFeature {
    public let viewModel: ModifyPlansViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, User>?
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var containerView = UIView()
    
    private lazy var contentView = ModifyPlansContentView()
    
    private lazy var tagCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
//        view.isScrollEnabled = false
        view.isUserInteractionEnabled = true
        view.register(ModifyMemberTagCVC.self)
        return view
    }()
    
    private lazy var doneButton = MYRTextButton("약속 수정하기", textColor: .neutral(.balck), font: .subtitle1, backgroundColor: .primary(.primary2), cornerRadius: 16)
    
    public init(viewModel: ModifyPlansViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateScrollViewContentSize()
    }
    
    public override func configureAttributes() {
        let titleView = MYRNavigationView(title: "약속 수정")
        self.setNavigationBar(isBackButton: true, titleView: titleView, rightButtonItem: nil)
        self.dataSource = self.generateDataSource()
    }
    public override func configureUI() {
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.doneButton)
        self.scrollView.addSubview(self.containerView)
        [self.contentView, self.tagCollectionView]
            .forEach { self.containerView.addSubview($0) }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(self.doneButton.snp.top).offset(-16)
        }
        
        self.contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.containerView.snp.makeConstraints { make in
            make.top.bottom.width.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(550)
        }
        
        self.tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(300)
        }
        
        self.doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    public override func bindViewModel() {
        let input = ModifyPlansViewModel.Input(
            titleText: self.contentView.titleTextField.rx.text.orEmpty.asObservable(),
            dateButtonDidTap: self.contentView.dateButton.rx.tap.asObservable(),
            locationButtonDidTap: self.contentView.locationButton.rx.tap.asObservable(),
            memberButtonDidTap: self.contentView.memberButton.rx.tap.asObservable(),
            doneButtonDidTap: self.doneButton.rx.tap
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                .asObservable()
        )
        
        let output = self.viewModel.trnasform(input: input)
        output.users
            .drive(with: self) { owner, users in
                let snapshot = owner.setSnapshot(dataSource: users)
                owner.dataSource?.apply(snapshot)
                owner.tagCollectionView.reloadData()
                owner.bindMemberButton(users)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.titleText.asDriver()
            .drive(with: self) { owner, title in
                owner.contentView.titleTextField.text = title
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.selectedDate.asDriver(onErrorJustReturn: nil)
//            .debug("selectedDate")
            .compactMap({ $0 })
            .map({ date in
                date.toStringWithCustomFormat(.yearToMinute, locale: nil)
            })
            .drive(with: self) { owner, dateString in
                print(dateString)
                owner.contentView.dateButton.setText(text: dateString)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.selectedLocation.asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(with: self) { owner, address in
                owner.contentView.locationButton.setText(text: address.name)
            }
            .disposed(by: self.disposeBag)
        
        output.result
            .subscribe(with: self) { owner, _ in
//                print("success")
                owner.viewModel.actions?.finishModifyPlansFeature()
            } onError: { owner, error in
//                print("\(error)")
                let toastView = MYRToastView(type: .failure, message: "약속 생성이 실패했습니다. 나중에 다시 시도해 주세요.", followsUndockedKeyboard: true)
                toastView.show(in: self.view)
            }
            .disposed(by: self.disposeBag)
    }
    
    // UICollectionView 높이 업데이트 및 UIScrollView contentSize 설정
    func updateScrollViewContentSize() {
        let collectionViewHeight = tagCollectionView.contentSize.height
        let contentViewHeight = self.contentView.frame.height
        let totalHeight = collectionViewHeight + contentViewHeight
        + 8 + 76
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: totalHeight)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: totalHeight)
    }

}

private extension ModifyPlansFeature {
    func generateDataSource() -> UICollectionViewDiffableDataSource<Int, User> {
        return UICollectionViewDiffableDataSource<Int, User>(collectionView: self.tagCollectionView,cellProvider: { [weak self] collectionView, indexPath, item in
            guard let self,
                  let tagCell = collectionView.dequeueCell(ModifyMemberTagCVC.self, for: indexPath)
            else { return UICollectionViewCell() }
            
            tagCell.bindCell(id: item.id, name: item.name)
            
            tagCell.tagView.xButton.rx.tap
                .compactMap({ _ in
                    self.dataSource?.itemIdentifier(for: indexPath)
                })
                .subscribe(onNext: { user in
                    self.viewModel.deleteTagedUser(user)
                })
                .disposed(by: tagCell.disposeBag)
            
            return tagCell
        })
    }
    
    func setSnapshot(dataSource: [User]) -> NSDiffableDataSourceSnapshot<Int, User> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
            snapshot.appendSections([0])
            snapshot.appendItems(dataSource, toSection: 0)
        return snapshot
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(40), heightDimension: .estimated(36))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(40), heightDimension: .estimated(36))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
            group.interItemSpacing = .fixed(8) // 아이템간 간격
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            return section
        }
    }
    
    func bindMemberButton(_ members: [User]) {
        if members.isEmpty {
            // 멤버가 없을 때 플레이스홀더 텍스트 설정
            self.contentView.memberButton.setText(text: "")
        } else if let name = members.first?.name {
            let memberCount = members.count - 1
            self.contentView.memberButton.setText(text: "\(name) 외 \(members.count - 1)명")
        }
    }
}
