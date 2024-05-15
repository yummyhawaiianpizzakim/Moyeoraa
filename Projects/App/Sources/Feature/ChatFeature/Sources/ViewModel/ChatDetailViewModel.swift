//
//  ChatDetailViewModel.swift
//  ChatFeature
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift
import RxCocoa
import RxRelay

public struct ChatDetailViewModelActions {
    var showLocationShareFeature: (_ id: String) -> Void
    var showPlansDetailFeature: (_ id: String) -> Void
    var exitChatDetailFeature: () -> Void
}

public final class ChatDetailViewModel: BaseViewModel {
    public typealias Action = ChatDetailViewModelActions
    public let disposeBag = DisposeBag()
    public var actions: Action?
    private let plansID: String
    private let chatRoomID: String
    public let chatRoomTitle: String
    public var chats: [Chat] = []
    private let toastTrigger = PublishRelay<Void>()
    
    private let observeChatUseCase: ObserveChatUseCaseProtocol
    private let sendChatUseCase: SendChatUseCaseProtocol
    private let updateIsCheckedUseCase: UpdateIsCheckedUseCaseProtocol
    private let checkLocationShareEnableUseCase: CheckLocationShareEnableUseCaseProtocol
    private let exitChatRoomUseCase: ExitChatRoomUseCaseProtocol
    
    public init(plansID: String,
                chatRoomID: String,
                chatRoomTitle: String,
                observeChatUseCase: ObserveChatUseCaseProtocol,
                sendChatUseCase: SendChatUseCaseProtocol,
                updateIsCheckedUseCase: UpdateIsCheckedUseCaseProtocol,
                checkLocationShareEnableUseCase: CheckLocationShareEnableUseCaseProtocol,
                exitChatRoomUseCase: ExitChatRoomUseCaseProtocol
    ) {
        self.plansID = plansID
        self.chatRoomID = chatRoomID
        self.chatRoomTitle = chatRoomTitle
        self.observeChatUseCase = observeChatUseCase
        self.sendChatUseCase = sendChatUseCase
        self.updateIsCheckedUseCase = updateIsCheckedUseCase
        self.checkLocationShareEnableUseCase = checkLocationShareEnableUseCase
        self.exitChatRoomUseCase = exitChatRoomUseCase
    }
    
    public struct Input {
        let mapButtonDidTap: Observable<Void>
        let sendButtonDidTapWithText: Observable<String>
        let chatRoomExitTrigger: Observable<Void>
    }
    
    public struct Output {
        let chats: Driver<[Chat]>
        let toastTrigger: Driver<Void>
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
            .withUnretained(self)
            .flatMap({ owner, _ in
                owner.checkLocationShareEnableUseCase.check(plansID: owner.plansID)
            })
            .subscribe(with: self) { owner, isEnable in
                isEnable ?
                owner.actions?.showLocationShareFeature(owner.chatRoomID)
                :
                owner.toastTrigger.accept(())
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
        
        input.chatRoomExitTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.exitChatRoomUseCase.exit(plansID: owner.plansID)
            }
            .subscribe(with: self) { owner, _ in
                owner.actions?.exitChatDetailFeature()
            }
            .disposed(by: self.disposeBag)
        
        return Output(chats: chats.asDriver(onErrorJustReturn: []), 
                      toastTrigger: self.toastTrigger.asDriver(onErrorJustReturn: ()))
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
    
    func showPlansDetailFeature() {
        self.actions?.showPlansDetailFeature(self.plansID)
    }
}
