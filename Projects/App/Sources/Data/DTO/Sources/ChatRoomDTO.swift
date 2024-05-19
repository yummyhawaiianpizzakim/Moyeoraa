//
//  ChatRoomDTO.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/24/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public struct ChatRoomDTO: Codable {
    public let id: String
    public let userID: String
    public let plansID: String
    public let updatedAt: String
    
     public init(id: String, userID: String, plansID: String, updatedAt: String) {
        self.id = id
        self.userID = userID
        self.plansID = plansID
        self.updatedAt = updatedAt
    }
    
    public func toEntity() -> ChatRoom {
        return .init(
            id: self.id,
            userID: self.userID,
            plansID: self.plansID,
            updatedAt: Date.fromStringOrNow(self.updatedAt)
        )
    }
}
