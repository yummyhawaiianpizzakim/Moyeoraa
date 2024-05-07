//
//  ChatDetailViewModel.swift
//  ChatFeature
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift
import RxCocoa

public struct ChatDetailViewModelActions {
    var showLocationShareFeature: (_ id: String) -> Void
}

public final class ChatDetailViewModel: BaseViewModel {
    public typealias Action = ChatDetailViewModelActions
    public let disposeBag = DisposeBag()
    public var actions: Action?
    private let chatRoomID: String
    public let chatRoomTitle: String
    public var chats: [Chat] = []
    
    private let observeChatUseCase: ObserveChatUseCaseProtocol
    private let sendChatUseCase: SendChatUseCaseProtocol
    private let updateIsCheckedUseCase: UpdateIsCheckedUseCaseProtocol
    
    public init(chatRoomID: String,
         chatRoomTitle: String,
         observeChatUseCase: ObserveChatUseCaseProtocol,
         sendChatUseCase: SendChatUseCaseProtocol,
                updateIsCheckedUseCase: UpdateIsCheckedUseCaseProtocol
    ) {
        self.chatRoomID = chatRoomID
        self.chatRoomTitle = chatRoomTitle
        self.observeChatUseCase = observeChatUseCase
        self.sendChatUseCase = sendChatUseCase
        self.updateIsCheckedUseCase = updateIsCheckedUseCase
    }
    
    public struct Input {
        let mapButtonDidTap: Observable<Void>
        let sendButtonDidTapWithText: Observable<String>
    }
    
    public struct Output {
        let chats: Driver<[Chat]>
    }
    
    public func trnasform(input: Input) -> Output {
        let chats = self.observeChatUseCase
            .observe(chatRoomID: self.chatRoomID)
            .do(onNext: { [weak self] chats in
                self?.chats = chats
//                print("self?.chats::\(self?.chats)")
            })
            .share()
        
        input.mapButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.actions?.showLocationShareFeature(owner.chatRoomID)
            }
            .disposed(by: self.disposeBag)
        
        input.sendButtonDidTapWithText
            .withUnretained(self)
            .flatMap { owner, content in
                owner.sendChatUseCase.send(content: content, chatRoomID: owner.chatRoomID)
            }
            .subscribe(with: self) { owner, _ in
                
            }
            .disposed(by: self.disposeBag)
        
        return Output(chats: chats.asDriver(onErrorJustReturn: []))
    }
    
    public func setAction(_ actions: ChatDetailViewModelActions) {
        self.actions = actions
    }
    
}

public extension ChatDetailViewModel {
    func hasMyChat(before index: Int) -> Bool {
            guard
                let prevChat = self.chats[safe: index - 1],
                let currentChat = self.chats[safe: index]
            else { return false }
            
        return prevChat.senderUserID == currentChat.senderUserID
        }
}
