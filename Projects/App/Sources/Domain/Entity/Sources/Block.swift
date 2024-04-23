//
//  Block.swift
//  Entity
//
//  Created by 김요한 on 2024/03/25.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public struct Block {
    public let blockId: String
    public let blockedUserId: String
    public let userId: String
    
    public init(blockId: String, blockedUserId: String, userId: String) {
        self.blockId = blockId
        self.blockedUserId = blockedUserId
        self.userId = userId
    }
}

public extension Block {
    struct BlockedUser: Hashable {
        public let blockId: String
        public let blockedUser: User
        
        public init(blockId: String, blockedUser: User) {
            self.blockId = blockId
            self.blockedUser = blockedUser
        }
    }
}
