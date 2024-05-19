//
//  ChatDTO.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/25/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public struct ChatDTO: Codable {
    public enum SenderType: String {
        case mine
        case other
    }
    
    public let id: String
    public let chatRoomID: String
    public let senderUserID: String
    public let senderType: String
    public let content: String
    public let createdAt: String
    public var isChecked: Bool
    
    public init(id: String,
                chatRoomID: String,
                senderUserID: String,
                senderType: SenderType,
                content: String,
                createdAt: String,
                isChecked: Bool
    ) {
        self.id = id
        self.chatRoomID = chatRoomID
        self.senderUserID = senderUserID
        self.senderType = senderType.rawValue
        self.content = content
        self.createdAt = createdAt
        self.isChecked = isChecked
    }
    
    public func toEntity(myID: String) -> Chat {
        var senderType: Chat.SenderType
        
        if self.senderUserID == myID {
            senderType = .mine
        } else {
            senderType = .other
        }
        
        return .init(
            id: self.id, 
            chatRoomID: self.chatRoomID,
            senderUserID: self.senderUserID,
            senderType: senderType,
            content: self.content,
            createdAt: Date.fromStringOrNow(self.createdAt),
            isChecked: self.isChecked
        )
    }
}

