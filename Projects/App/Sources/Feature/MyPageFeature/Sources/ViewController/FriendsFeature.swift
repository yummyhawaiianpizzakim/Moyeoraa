//
//  FriendsFeature.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public final class FriendsFeature: BaseFeature {
    private let viewModel: FriendsViewModel
    
    private var friendsDataSource: UITableViewDiffableDataSource<Int, Friend>?
    private var usersDataSource: UITableViewDiffableDataSource<Int, User>?
    
    private var friendsSnapshot: NSDiffableDataSourceSnapshot<Int, Friend>?
    private var usersSnapshot: NSDiffableDataSourceSnapshot<Int, User>?
    
    var currentPage: Int = 0 {
        didSet {
            // from segmentedControl -> pageViewController 업데이트
//            print(oldValue, self.currentPage)
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    var dataViewControllers: [UIViewController] {
      [self.vc1, self.vc2]
    }
    
    private lazy var searchView = MYRSearchView()
    
    private lazy var segmentedControl = MYRSegmentedControl(items: ["친구", "유저"])
    
    private lazy var vc1 = UIViewController()
    
    private lazy var vc2 = UIViewController()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private lazy var friendsTableView: UITableView = {
        let view = UITableView()
        view.register(FriendsTVC.self)
        view.separatorStyle = .none
        view.delegate = self
        return view
    }()
    
    private lazy var usersTableView: UITableView = {
        let view = UITableView()
        view.register(SearchUserTVC.self)
        view.separatorStyle = .none
        view.delegate = self
        return view
    }()
    
    public init(viewModel: FriendsViewModel) {
        self.viewModel = viewModel
        super.init()
        self.bindUI()
    }
    
    public override func configureAttributes() {
        self.setNavigationBar(isBackButton: true, titleView: self.searchView, rightButtonItem: nil)
        self.friendsDataSource = self.generateFriendsDataSource()
        self.usersDataSource = self.generateUsersDataSource()
    }
    
    public override func configureUI() {
        [self.segmentedControl,
         self.pageViewController.view
//         self.friendsTableView
        ]
            .forEach { self.view.addSubview($0) }
        
        self.vc1.view.addSubview(self.friendsTableView)
        self.vc2.view.addSubview(self.usersTableView)
        
        self.segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(51)
        }
        
        self.pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.friendsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.usersTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindUI() {
        self.segmentedControl.rx
            .selectedSegmentIndex
            .asObservable()
//            .debug("segmentedControl")
            .subscribe(with: self) { owner, index in
                owner.currentPage = index
            }
            .disposed(by: self.disposeBag)
    }
    
    public override func bindViewModel() {
        let searchText = self.searchView.iconTextField.rx.text.orEmpty.debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .filter({ [weak self] keyword in
                guard let self else { return false }
                switch self.currentPage {
                case 0:
                    self.queryDataSource(keyword: keyword)
                    return false
                case 1:
                    return true
                default:
                    return false
                }
            })
            .asObservable()
        
        let input = FriendsViewModel.Input(searchUsers: searchText)
        let output = self.viewModel.trnasform(input: input)
        
        output.friends
//            .debug("friends")
            .drive(with: self) { owner, friends in
            let snapshot = owner.setFriendsSnapshot(friends: friends)
            owner.friendsSnapshot = snapshot
            owner.friendsDataSource?.apply(snapshot)
        }
        .disposed(by: self.disposeBag)
        
        output.users
//            .debug("users")
            .drive(with: self) { owner, users in
            let snapshot = owner.setUsersSnapshot(users: users)
            owner.usersSnapshot = snapshot
            owner.usersDataSource?.apply(snapshot)
        }
        .disposed(by: self.disposeBag)
    }
}

private extension FriendsFeature {
    func queryDataSource(keyword: String) {
        guard let dataSource = self.friendsDataSource else { return }
        
        if keyword.isEmpty {
            // 검색어가 비어있을 때는 모든 데이터를 다시 보여줍니다.
            guard let allUsers = self.friendsSnapshot?.itemIdentifiers else { return }
            
            var newSnapshot = NSDiffableDataSourceSnapshot<Int, Friend>()
            newSnapshot.appendSections([0])
            newSnapshot.appendItems(allUsers, toSection: 0)
            dataSource.apply(newSnapshot, animatingDifferences: true)
        } else {
            // 검색어가 있을 때 필터링 로직
            guard var snapshot = self.friendsSnapshot
            else { return }
            
            let filteredName = snapshot.itemIdentifiers.filter({ user in
                let name = user.name
                return name.hasPrefix(keyword)
            })
            
            let filteredTag = snapshot.itemIdentifiers.filter({ user in
                let tag = String(user.tagNumber)
                return tag.hasPrefix(keyword)
            })
            
            snapshot = NSDiffableDataSourceSnapshot<Int, Friend>()
            snapshot.appendSections([0])
            snapshot.appendItems(filteredName + filteredTag, toSection: 0)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension FriendsFeature: UITableViewDelegate {
    private func generateFriendsDataSource() -> UITableViewDiffableDataSource<Int, Friend> {
        return UITableViewDiffableDataSource<Int, Friend>(tableView: self.friendsTableView) { [weak self] tableView, indexPath, friend in
            guard let self,
                  let friendsCell = tableView.dequeueCell(FriendsTVC.self, for: indexPath)
            else { return UITableViewCell() }
            friendsCell.bindCell(profileURL: friend.prfileImage ?? "",
                                 userName: friend.name,
                                 userTag: friend.tagNumber)
            
            return friendsCell
        }
    }
    
    private func generateUsersDataSource() -> UITableViewDiffableDataSource<Int, User> {
        return UITableViewDiffableDataSource<Int, User>(tableView: self.usersTableView) { [weak self] tableView, indexPath, item in
            guard let self,
                  let searchUserCell = tableView.dequeueCell(SearchUserTVC.self, for: indexPath)
            else { return UITableViewCell() }
            searchUserCell.bindCell(profileURL: item.profileImage ?? "", userName: item.name, userTag: item.tagNumber)
            
            searchUserCell.plusButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .compactMap { _ in
                    self.usersDataSource?.itemIdentifier(for: indexPath)
                }
                .do(onNext: { _ in
                    searchUserCell.isPlusButtonSelected.toggle()
                })
                .map { user in
                    (user.id,
                     searchUserCell.isPlusButtonSelected)
                }
                .subscribe(onNext: { id, isSelected in
                    self.viewModel.modifyFriend(id, isSelected: isSelected)
                })
                .disposed(by: searchUserCell.disposeBag)
            
            return searchUserCell
        }
    }
    
    private func setFriendsSnapshot(friends: [Friend]) -> NSDiffableDataSourceSnapshot<Int, Friend> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Friend>()
        snapshot.appendSections([0])
        snapshot.appendItems(friends)
        return snapshot
    }
    
    private func setUsersSnapshot(users: [User]) -> NSDiffableDataSourceSnapshot<Int, User> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(users)
        return snapshot
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension FriendsFeature: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.dataViewControllers.firstIndex(of: viewController),
            index - 1 >= 0
        else { return nil }
        return self.dataViewControllers[index - 1]
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.dataViewControllers.firstIndex(of: viewController),
            index + 1 < self.dataViewControllers.count
        else { return nil }
        return self.dataViewControllers[index + 1]
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = self.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}
