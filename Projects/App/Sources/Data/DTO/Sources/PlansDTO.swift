//
//  PlansDTO.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/24/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public struct PlansDTO: Codable {
    public enum Status: String {
        case active
        case inactive
    }
    
    public let id: String
    public let title: String
    public let date: String
    public let location: String
    public let latitude: Double
    public let longitude: Double
    public var imageURLString: String?
    public let makingUserID: String
    public let usersID: [String]
    public let chatRoomID: String
    public var status: String
    
    
    public init(id: String, title: String, date: String, location: String, latitude: Double, longitude: Double, imageURLString: String? = nil, makingUserID: String, usersID: [String], chatRoomID: String, status: Status) {
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
        self.status = status.rawValue
    }
}
