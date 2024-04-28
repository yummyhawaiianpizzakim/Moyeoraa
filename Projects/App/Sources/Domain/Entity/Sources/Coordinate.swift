//
//  Coordinate.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/28/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public struct Coordinate: Encodable {
    public let lat: Double
    public let lng: Double
    
    static var seoulCoordinate = Coordinate(lat: 37.553836, lng: 126.969652)
    
    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}
