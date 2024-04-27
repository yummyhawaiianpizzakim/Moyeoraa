//
//  ObserveChatUseCaseImpl.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class ObserveChatUseCaseImpl: ObserveChatUseCaseProtocol {
    private let chatRepository: ChatRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    public init(chatRepository: ChatRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        self.chatRepository = chatRepository
        self.userRepository = userRepository
    }
    
    public func observe(chatRoomID: String) -> Observable<[Chat]> {
        self.chatRepository.observeChat(chatRoomID: chatRoomID)
            .withUnretained(self)
            .flatMap { owner, chats in
                let ids = chats.map { $0.senderUserID }
                    .removingDuplicates()
                
                return owner.userRepository.getUsersInfo(ids)
                    .map { users in
                        owner.mapChatWithUser(chats: chats, users: users)
                    }
            }
        
    }
    
    private func mapChatWithUser(chats: [Chat], users: [User]) -> [Chat] {
        var mapedChats: [Chat] = []
        
        chats.forEach { chat in
            users.forEach { user in
                if chat.senderUserID == user.id {
                    var mutableChat = chat
                    mutableChat.user = user
                    mapedChats.append(mutableChat)
                }
            }
        }
        
        return mapedChats
    }
}
