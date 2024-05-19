//
//  FriendDTO.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/28/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public struct FriendDTO: Codable {
    public let id: String
    public let name: String
    public let tagNumber: String
    public let prfileImage: String?
    public let followingUserID: String
    public let userID: String
    
    public init(id: String, name: String, tagNumber: String, prfileImage: String?, followingUserID: String, userID: String) {
        self.id = id
        self.name = name
        self.tagNumber = tagNumber
        self.prfileImage = prfileImage
        self.followingUserID = followingUserID
        self.userID = userID
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    public func toEntity() -> Friend {
        let tagNumber = Int(self.tagNumber)
        
        return .init(
            id: self.id,
            name: self.name,
            tagNumber: tagNumber ?? 1000,
            prfileImage: self.prfileImage,
            followingUserID: self.followingUserID,
            userID: self.userID
        )
    }
}
