//
//  ChatRoom.swift
//  Entity
//
//  Created by 김요한 on 2024/03/25.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public struct ChatRoom: Hashable {
    public let id: String
    public let userID: String
    public let plansID: String
    public let updatedAt: Date
    
     public init(id: String, userID: String, plansID: String, updatedAt: Date) {
        self.id = id
        self.userID = userID
        self.plansID = plansID
        self.updatedAt = updatedAt
    }
    
    public static func stub(id: String, userID: String, plansID: String) -> Self {
        return .init(id: id, userID: userID, plansID: plansID, updatedAt: Date().localizedDate())
    }
}
