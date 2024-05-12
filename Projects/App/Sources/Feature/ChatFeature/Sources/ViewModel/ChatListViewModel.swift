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
    public var showChatDetailFeature: (_ plansID: String, _ chatRoomID: String, _ title: String) -> Void
}

public final class ChatListViewModel: BaseViewModel {
    public typealias Action = ChatListViewModelActions
    public let disposeBag = DisposeBag()
    public var actions: Action?
    
    public let fetchChatUseCase: ObserveChatListUseCaseProtocol
    
    public init(fetchChatUseCase: ObserveChatListUseCaseProtocol
    ) {
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
            .debug("viewDidAppear")
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<([ChatRoom], [Plans], [Chat])> in
                owner.fetchChatUseCase.observe()
            }
            .withUnretained(self)
            .map({ owner, val -> [ChatList] in
                let (chatRooms, plans, chats) = val
                return owner.mapPlansAndChatRoom(chatRooms: chatRooms, plansArr: plans, chats: chats)
            })
            .map({ $0.sorted { $0.updateAt > $1.updateAt } })
            .asDriver(onErrorJustReturn: [])
        //
        input.cellDidSelect
        //            .debug("cellDidSelect")
            .subscribe(with: self) { owner, chatList in
                guard let chatList else { return }
                owner.actions?.showChatDetailFeature(chatList.PlansId, chatList.chatroomId, chatList.title)
            }
            .disposed(by: self.disposeBag)
        
        return Output(ChatLists: chatLists)
    }
    
    public func setAction(_ actions: ChatListViewModelActions) {
        self.actions = actions
    }
}

private extension ChatListViewModel {
    func mapPlansAndChatRoom(chatRooms: [ChatRoom], plansArr: [Plans], chats: [Chat]) -> [ChatList] {
        // plansArr을 Dictionary로 변환하여 O(1) 접근이 가능하도록 함
        let plansDict = Dictionary(uniqueKeysWithValues: plansArr.map { ($0.id, $0) })
        
        // chatRooms을 Dictionary로 변환하여 O(1) 접근이 가능하도록 함
        let chatRoomDict = Dictionary(uniqueKeysWithValues: chatRooms.map({ ($0.plansID, $0) }))
        
        // chats를 chatRoomID를 기준으로 Dictionary로 변환
        let chatDict = Dictionary(uniqueKeysWithValues: chats.map({ ($0.chatRoomID, $0) }))
        
        // 결과를 저장할 배열
        //        var mappedResults = [MappedObject]()
        var mappedResults = [ChatList]()
        
        for (id, plans) in plansDict {
            if let chatRoom = chatRoomDict[id] {
                let chat = chatDict[chatRoom.id]
                
                var isChecked = false
                if chat?.senderType == .mine {
                    isChecked = true
                } else {
                    isChecked = false
                }
                
                let chatList = ChatList(
                    chatroomId: chatRoom.id,
                    PlansId: plans.id,
                    profileImage: plans.imageURLString,
                    title: plans.title,
                    location: plans.location,
                    date: plans.date,
                    updateAt: chat?.createdAt ?? chatRoom.updatedAt,
                    isChecked: isChecked
                )
                
                mappedResults.append(chatList)
            }
        }
        
        mappedResults.sort { $0.updateAt > $1.updateAt }
        
        return mappedResults
    }
}
