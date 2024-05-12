//
//  ChatListFeature.swift
//  ChatFeatureInterface
//
//  Created by 김요한 on 2024/03/29.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class ChatListFeature: BaseFeature {
    public let viewModel: ChatListViewModel
    
    public var dataSource: UITableViewDiffableDataSource<Int, ChatList>?
    
    private lazy var chatListTableView: UITableView = {
        let view = UITableView()
        view.register(MYRChatListTVC.self)
        view.delegate = self
        return view
    }()
    
    private lazy var emptyView = MYREmptyView()
    
    public init(viewModel: ChatListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func configureAttributes() {
        let view = MYRNavigationView(title: "채팅 목록")
        self.setNavigationBar(isBackButton: true, titleView: view, rightButtonItem: nil)
        self.emptyView.type = .chatList
        self.emptyView.isHidden = true
    }
    
    public override func configureUI() {
        [self.chatListTableView, self.emptyView].forEach { self.view.addSubview($0)
        }
        
        self.chatListTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.emptyView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    public override func bindViewModel() {
        let input = ChatListViewModel.Input(
            viewDidAppear: self.rx.viewDidAppear
                .map({ _ in }).asObservable(),
            cellDidSelect: self.chatListTableView.rx.itemSelected
                .asObservable()
                .map({ [weak self] indexPath in
                    self?.dataSource?.itemIdentifier(for: indexPath)
                })
        )
        
        let output = self.viewModel.trnasform(input: input)
        
        output.ChatLists
            .drive(with: self) { owner, chatLists in
                owner.emptyView.bindEmptyView(isEmpty: chatLists.isEmpty)
                
                owner.dataSource = owner.generateDataSource()
                let snapshot = owner.setSnapshot(chatLists: chatLists)
                owner.dataSource?.apply(snapshot)
                owner.chatListTableView.reloadData()
            }
            .disposed(by: self.disposeBag)
    }
}

extension ChatListFeature: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    private func generateDataSource() -> UITableViewDiffableDataSource<Int, ChatList> {
        let dataSource = UITableViewDiffableDataSource<Int, ChatList>(tableView: self.chatListTableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueCell(MYRChatListTVC.self, for: indexPath)
            else { return UITableViewCell() }
            cell.bindChatInfo(time: item.updateAt, isChecked: item.isChecked)
            cell.bindPlansInfo(profileURL: item.profileImage ?? "", title: item.title, location: item.location, date: item.date)
            return cell
        }
        return dataSource
    }
    
    private func setSnapshot(chatLists: [ChatList]) -> NSDiffableDataSourceSnapshot<Int, ChatList> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChatList>()
        snapshot.appendSections([0])
        snapshot.appendItems(chatLists)
        return snapshot
    }
}
