//
//  ChatListViewModel.swift
//  ChatFeatureInterface
//
//  Created by 김요한 on 2024/03/29.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public struct ChatListViewModelActions {
    public var showChatDetailFeature: (_ id: String, _ title: String) -> Void
}

public final class ChatListViewModel: BaseViewModel {
    public typealias Action = ChatListViewModelActions
    public let disposeBag = DisposeBag()
    public var actions: Action?
    public let fetchChatUseCase: ObserveChatListUseCaseProtocol
    
    public init(fetchChatUseCase: ObserveChatListUseCaseProtocol) {
        self.fetchChatUseCase = fetchChatUseCase
    }
    
    public struct Input {
        let viewDidAppear: Observable<Void>
        let cellDidSelect: Observable<ChatList?>
    }
    
    public struct Output {
        let ChatLists: Driver<[ChatList]>
    }
    
    public func trnasform(input: Input) -> Output {
        let chatLists = input.viewDidAppear
//            .debug("viewDidAppear")
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<[ChatList]> in
                owner.fetchChatUseCase.observe()
                    .map { val in
                        let (chatRooms, plansArr) = val
                        return owner.mapChatLists(chatRooms: chatRooms, plansArr: plansArr)
                    }
            }
            .asDriver(onErrorJustReturn: [])
        
        input.cellDidSelect
//            .debug("cellDidSelect")
            .subscribe(with: self) { owner, chatList in
                guard let chatList else { return }
                owner.actions?.showChatDetailFeature(chatList.chatroomId, chatList.title)
            }
            .disposed(by: self.disposeBag)
        
        return Output(ChatLists: chatLists)
    }
    
    public func setAction(_ actions: ChatListViewModelActions) {
        self.actions = actions
    }
    
}

private extension ChatListViewModel {
    func mapChatLists(chatRooms: [ChatRoom], plansArr: [Plans]) -> [ChatList] {
        var chatLists: [ChatList] = []
        chatRooms.forEach { chatRoom in
            plansArr.forEach { plans in
                if chatRoom.plansID == plans.id {
                    let chatList = ChatList(chatroomId: chatRoom.id, PlansId: plans.id, profileImage: plans.imageURLString, title: plans.title, location: plans.location, date: plans.date, updateAt: chatRoom.updatedAt, isChecked: false)
                    chatLists.append(chatList)
                }
            }
        }
        return chatLists
    }
}
