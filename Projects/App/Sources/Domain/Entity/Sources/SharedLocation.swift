//
//  SharedLocation.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/4/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public struct SharedLocation: Codable {
    
    public let userID: String
    public let latitude: Double
    public let longitude: Double
    
    public init(userID: String, latitude: Double, longitude: Double) {
        self.userID = userID
        self.latitude = latitude
        self.longitude = longitude
    }
    
    private enum CodingKeys: String, CodingKey {
        case userID, latitude, longitude
    }
}
