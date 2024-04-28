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
    public let tagNumber: String
    public let profileImage: String?
    public let fcmToken: String
    
    public init(id: String,
                name: String,
                tagNumber: String,
                profileImage: String? = nil,
                fcmToken: String) {
        self.id = id
        self.name = name
        self.tagNumber = tagNumber
        self.profileImage = profileImage
        self.fcmToken = fcmToken
    }
    
    public func toEntity() -> User {
        let tagNumber = Int(self.tagNumber)
        
        return .init(
            id: self.id,
            name: self.name,
            tagNumber: tagNumber ?? 1000,
            profileImage: self.profileImage,
            fcmToken: self.fcmToken,
            isNotification: false
        )
    }
}
