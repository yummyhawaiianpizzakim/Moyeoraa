//
//  Friend.swift
//  Entity
//
//  Created by 김요한 on 2024/03/27.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public struct Friend: Hashable {
    public let id: String
    public let name: String
    public let tagNumber: Int
    public let prfileImage: String?
    public let followingUserID: String
    public let userID: String
    
    public init(id: String, name: String, tagNumber: Int, prfileImage: String?, followingUserID: String, userID: String) {
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
}
