//
//  ChatDetailFeature.swift
//  ChatFeature
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class ChatDetailFeature: BaseFeature {
    public let viewModel: ChatDetailViewModel
    
    private let exitTrigger = PublishRelay<Void>()
    
    public var dataSource: UITableViewDiffableDataSource<Int, Chat>?
    
    private lazy var menuButton = UIBarButtonItem(title: nil, image: .Moyeora.menu, target: nil, action: nil, menu: self.createUIMenu())
    
    private lazy var chatTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(ChatTVC.self)
        view.separatorStyle = .none
        view.allowsSelection = false
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    private lazy var chatInputView = ChatInputView()
    
    public init(viewModel: ChatDetailViewModel) {
        self.viewModel = viewModel
        super.init()
        self.bindUI()
    }
    
    public override func configureAttributes() {
        let title = self.viewModel.chatRoomTitle
        let view = MYRNavigationView(title: title)
        self.setNavigationBar(isBackButton: true, titleView: view, rightButtonItem: self.menuButton)
        self.view.backgroundColor = .white
    }
    
    public override func configureUI() {
        [self.chatTableView, self.chatInputView]
            .forEach { self.view.addSubview($0) }
        
        self.chatTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(self.chatInputView.snp.top)
        }
        
        self.chatInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
    }
    
    private func bindUI() {
        self.chatInputView.followKeyboardObserver()
            .disposed(by: self.disposeBag)
        
        self.chatTableView.followKeyboardObserver()
            .disposed(by: self.disposeBag)
    }
    
    public override func bindViewModel() {
        let input = ChatDetailViewModel.Input(
            mapButtonDidTap: self.chatInputView.mapButtonDidTap,
            sendButtonDidTapWithText: self.chatInputView.sendButtonDidTapWithText,
            chatRoomExitTrigger: self.exitTrigger.asObservable()
        )
        
        let output = self.viewModel.trnasform(input: input)
        output.chats
//            .debug("chats")
            .drive(with: self) { owner, chats in
                owner.dataSource = owner.generateDataSource()
                let snapshot = owner.setSnapshot(chats: chats)
                owner.dataSource?.apply(snapshot)
            }
            .disposed(by: self.disposeBag)
        
        output.toastTrigger
            .drive(with: self) { owner, _ in
                owner.showLocationShareFailedAlert()
            }
            .disposed(by: self.disposeBag)
    }
}

extension ChatDetailFeature: UITableViewDelegate {
    private func generateDataSource() -> UITableViewDiffableDataSource<Int, Chat> {
        let dataSource = UITableViewDiffableDataSource<Int, Chat>(tableView: self.chatTableView) { [weak self] tableView, indexPath, item in
            guard let self, let cell = tableView.dequeueCell(ChatTVC.self, for: indexPath)
            else { return UITableViewCell() }
            
            let hasMyChatBefore = self.viewModel.hasMyChat(before: indexPath.row)
            
            cell.bindCell(by: item, hasMyChatBefore: hasMyChatBefore) {
                guard var snapshot = self.dataSource?.snapshot() else { return }
                snapshot.reloadItems([item])
            }
            
            return cell
        }
        return dataSource
    }
    
    private func setSnapshot(chats: [Chat]) -> NSDiffableDataSourceSnapshot<Int, Chat> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Chat>()
        snapshot.appendSections([0])
        snapshot.appendItems(chats)
        return snapshot
    }
}

private extension ChatDetailFeature {
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
                title: "약속 정보",
                handler: { [weak self] _ in
                    self?.viewModel.showPlansDetailFeature()
                }
            ),
            UIAction(
                title: "채팅방 나가기",
                attributes: [.destructive],
                handler: { [weak self] _ in
                    self?.showOutAlert()
                })
        ]
    }
    
    func showOutAlert() {
        let alert = MYRAlertController(
            title: "채팅방 나가기",
            message: "정말 채팅방에서 나가시겠습니까?\n 나가면 약속에서도 제외 됩니다.",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let logout = UIAlertAction(title: "나가기", style: .destructive) { [weak self] _ in
            self?.exitTrigger.accept(())
        }
        
        alert.addActions([cancel, logout])
        
        present(alert, animated: true, completion: nil)
    }
    
    func showLocationShareFailedAlert() {
        let alert = MYRAlertController(
            title: "맴버 위치 공유",
            message: "위치 공유는 약속 당일에만 이용할 수 있습니다.",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "확인", style: .cancel)
        alert.addActions([cancel])
        
        present(alert, animated: true, completion: nil)
    }
}
