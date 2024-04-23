//
//  Address.swift
//  Entity
//
//  Created by 김요한 on 2024/04/08.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public struct Address {
    public let id: String
    public let name: String
    public let address: String
    public let lat: Double
    public let lng: Double
    
    public init(id: String, name: String, address: String, lat: Double, lng: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.lat = lat
        self.lng = lng
    }
}

extension Address: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
