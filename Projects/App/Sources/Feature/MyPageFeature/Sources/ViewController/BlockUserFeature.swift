//
//  BlockUserFeature.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

public final class BlockUserFeature: BaseFeature {
    private let viewModel: BlockUserViewModel
    
    private var dataSource: UITableViewDiffableDataSource<Int, Block.BlockedUser>?
    
    //패치받고 초기 스냅샷
    private var snapshot: NSDiffableDataSourceSnapshot<Int, Block.BlockedUser>?
    
    private lazy var searchView = MYRSearchView()
    
    private lazy var blockUserTableView: UITableView = {
        let view = UITableView()
        view.register(BlockUserTVC.self)
        view.separatorStyle = .none
        view.delegate = self
        return view
    }()
    
    private lazy var emptyView = MYREmptyView()
    
    public init(viewModel: BlockUserViewModel) {
        self.viewModel = viewModel
        super.init()
        self.bindUI()
    }
    
    public override func configureAttributes() {
        self.dataSource = self.generateDataSource()
        self.setNavigationBar(isBackButton: true, titleView: self.searchView, rightButtonItem: nil)
        self.view.backgroundColor = .white
        self.emptyView.type = .block
        self.emptyView.isHidden = true
    }
    
    public override func configureUI() {
        [self.blockUserTableView, self.emptyView].forEach { self.view.addSubview($0) }
        
        self.blockUserTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.emptyView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func bindUI() {
        self.searchView.iconTextField.rx.text.orEmpty
            .skip(1)
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, keyword in
                owner.queryDataSource(keyword: keyword)
            }
            .disposed(by: self.disposeBag)
    }
    
    func queryDataSource(keyword: String) {
        guard let dataSource = self.dataSource else { return }
        
        if keyword.isEmpty {
            // 검색어가 비어있을 때는 모든 데이터를 다시 보여줍니다.
            guard let allUsers = self.snapshot?.itemIdentifiers else { return }
            
            var newSnapshot = NSDiffableDataSourceSnapshot<Int, Block.BlockedUser>()
            newSnapshot.appendSections([0])
            newSnapshot.appendItems(allUsers, toSection: 0)
            dataSource.apply(newSnapshot, animatingDifferences: true)
        } else {
            // 검색어가 있을 때 필터링 로직
            guard var snapshot = self.snapshot
            else { return }
            
            let filteredName = snapshot.itemIdentifiers.filter({ user in
                let name = user.blockedUser.name
                return name.hasPrefix(keyword)
            })
            
            let filteredTag = snapshot.itemIdentifiers.filter({ user in
                let tag = String(user.blockedUser.tagNumber)
                return tag.hasPrefix(keyword)
            })
            
            snapshot = NSDiffableDataSourceSnapshot<Int, Block.BlockedUser>()
            snapshot.appendSections([0])
            snapshot.appendItems(filteredName + filteredTag, toSection: 0)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    public override func bindViewModel() {
        let input = BlockUserViewModel.Input(
        )
        let output = self.viewModel.trnasform(input: input)
        
        output.dataSource
        .drive(with: self) { owner, users in
            owner.emptyView.bindEmptyView(isEmpty: users.isEmpty)
            owner.snapshot = owner.setSnapshot(dataSource: users)
            guard let snapshot = owner.snapshot else { return }
            owner.dataSource?.apply(snapshot)
        }
        .disposed(by: self.disposeBag)
    }
}

extension BlockUserFeature: UITableViewDelegate {
    private func generateDataSource() -> UITableViewDiffableDataSource<Int, Block.BlockedUser> {
        return UITableViewDiffableDataSource<Int, Block.BlockedUser>(tableView: self.blockUserTableView) {[weak self] tableView, indexPath, item in
            guard let self,
                  let cell = tableView.dequeueCell(BlockUserTVC.self, for: indexPath) else { return UITableViewCell() }
            
            cell.bindCell(profileURL: item.blockedUser.profileImage ?? "", userName: item.blockedUser.name, userTag: item.blockedUser.tagNumber)
            
            cell.blockButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .asObservable()
                .compactMap({ _ in
                    self.dataSource?.itemIdentifier(for: indexPath)
                })
                .do(onNext: { _ in
                    cell.isBlockButtonSelected.toggle()
                })
                .map({ user in
                    (user.blockedUser.id,
                     cell.isBlockButtonSelected)
                })
                .subscribe(onNext: { id, isSelected in
                    self.viewModel.modifyBlockUser(id, isSelected: isSelected)
                })
                .disposed(by: cell.disposeBag)
                
            return cell
        }
    }
    
    private func setSnapshot(dataSource: [Block.BlockedUser]) -> NSDiffableDataSourceSnapshot<Int, Block.BlockedUser> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Block.BlockedUser>()
        snapshot.appendSections([0])
        snapshot.appendItems(dataSource, toSection: 0)
        return snapshot
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
