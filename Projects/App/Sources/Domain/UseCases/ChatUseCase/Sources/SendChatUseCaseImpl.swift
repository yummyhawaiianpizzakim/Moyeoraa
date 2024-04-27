//
//  SendChatUseCaseImpl.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/31.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class SendChatUseCaseImpl: SendChatUseCaseProtocol {
    private let chatRepository: ChatRepositoryProtocol
    
    public init(chatRepository: ChatRepositoryProtocol) {
        self.chatRepository = chatRepository
    }
    
    public func send(content: String, chatRoomID: String) -> Observable<Void> {
       return self.chatRepository.send(content: content, at: chatRoomID)
    }
}
