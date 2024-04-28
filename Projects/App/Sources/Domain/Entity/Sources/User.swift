//
//  User.swift
//  Entity
//
//  Created by 김요한 on 2024/03/25.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public struct User: Hashable {
    public let id: String
    public let name: String
    public let tagNumber: Int
    public let profileImage: String?
    public let fcmToken: String
    public var isNotification: Bool
    
    public init(id: String,
                name: String,
                tagNumber: Int,
                profileImage: String? = nil,
                fcmToken: String,
                isNotification: Bool) {
        self.id = id
        self.name = name
        self.tagNumber = tagNumber
        self.profileImage = profileImage
        self.fcmToken = fcmToken
        self.isNotification = isNotification
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
