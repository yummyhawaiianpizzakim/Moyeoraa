//
//  BlockDTO.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/30/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public struct BlockDTO: Codable {
    public let blockId: String
    public let blockedUserId: String
    public let userId: String
    
    public init(blockId: String, blockedUserId: String, userId: String) {
        self.blockId = blockId
        self.blockedUserId = blockedUserId
        self.userId = userId
    }
    
    public func toEntity() -> Block {
        return .init(
            blockId: self.blockId,
            blockedUserId: self.blockedUserId,
            userId: self.userId
        )
    }
}
