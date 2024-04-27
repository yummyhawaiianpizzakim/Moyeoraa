//
//  Chat.swift
//  Entity
//
//  Created by 김요한 on 2024/03/25.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public struct Chat {
     public enum SenderType {
         case mine
         case other
     }
     
    public let id: String
    public let chatRoomID: String
    public let senderUserID: String
    public let senderType: SenderType
    public let content: String
    public let createdAt: Date
    public var isChecked: Bool
    
    public var user: User?
    
    public init(id: String,
                chatRoomID: String,
                senderUserID: String,
                senderType: SenderType,
                content: String,
                createdAt: Date,
                isChecked: Bool,
                user: User? = nil
    ) {
        self.id = id
        self.chatRoomID = chatRoomID
        self.senderUserID = senderUserID
        self.senderType = senderType
        self.content = content
        self.createdAt = createdAt
        self.isChecked = isChecked
        self.user = user
    }
}

extension Chat: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

