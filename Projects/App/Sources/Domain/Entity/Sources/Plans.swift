//
//  Plans.swift
//  Entity
//
//  Created by 김요한 on 2024/03/25.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public struct Plans: Hashable {
    public enum Status {
        case active
        case inactive
    }
    
    public let id: String
    public let title: String
    public let date: Date
    public let location: String
    public let latitude: Double
    public let longitude: Double
    public var imageURLString: String?
    public let makingUserID: String
    public let usersID: [String]
    public let chatRoomID: String
    public var status: Status
    
    
    public init(id: String, title: String, date: Date, location: String, latitude: Double, longitude: Double, imageURLString: String? = nil, makingUserID: String, usersID: [String], chatRoomID: String, status: Status) {
        self.id = id
        self.title = title
        self.date = date
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.imageURLString = imageURLString
        self.makingUserID = makingUserID
        self.usersID = usersID
        self.chatRoomID = chatRoomID
        self.status = status
    }
}

public extension Plans {
    static func stub(title: String, date: Date) -> Self {
        return self.init(
            id: UUID().uuidString,
            title: title,
            date: date,
            location: "스벅",
            latitude: 0.0,
            longitude: 0.0,
            makingUserID: "1234",
            usersID: ["1","2","3"],
            chatRoomID: UUID().uuidString,
            status: .active
        )
    }
    
    static func stub(id: String, title: String, date: Date) -> Self {
        return self.init(
            id: id,
            title: title,
            date: date,
            location: "스벅",
            latitude: 0.0,
            longitude: 0.0,
            makingUserID: "1234",
            usersID: ["1","2","3"],
            chatRoomID: UUID().uuidString,
            status: .active
        )
    }
}
