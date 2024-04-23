//
//  ChatPreview.swift
//  ChatFeatureInterface
//
//  Created by 김요한 on 2024/03/29.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public struct ChatList: Hashable {
    public let chatroomId: String
    public let PlansId: String
    public let profileImage: String?
    public let title: String
    public let location: String
    public let date: Date
    public let updateAt: Date
    public var isChecked: Bool
    
    public init(chatroomId: String,
                PlansId: String,
                profileImage: String?,
                title: String,
                location: String,
                date: Date,
                updateAt: Date,
                isChecked: Bool) {
        self.chatroomId = chatroomId
        self.PlansId = PlansId
        self.profileImage = profileImage
        self.title = title
        self.location = location
        self.date = date
        self.updateAt = updateAt
        self.isChecked = isChecked
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(chatroomId)
    }
}

extension ChatList: Comparable {
    public static func < (lhs: ChatList, rhs: ChatList) -> Bool {
        return lhs.date < rhs.date
    }
}
