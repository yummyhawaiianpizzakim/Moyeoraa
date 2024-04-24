//
//  UserDTO.swift
//  DTO
//
//  Created by 김요한 on 2024/04/21.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public struct UserDTO: Codable {
    public let id: String
    public let name: String
    public let tagNumber: Int
    public let profileImage: String?
    public let fcmToken: String
    
    public init(id: String,
                name: String,
                tagNumber: Int,
                profileImage: String? = nil,
                fcmToken: String) {
        self.id = id
        self.name = name
        self.tagNumber = tagNumber
        self.profileImage = profileImage
        self.fcmToken = fcmToken
    }
    
    public func toEntity() -> User {
        return .init(
            id: self.id,
            name: self.name,
            tagNumber: self.tagNumber,
            profileImage: self.profileImage,
            fcmToken: self.fcmToken,
            isNotification: false
        )
    }
}
