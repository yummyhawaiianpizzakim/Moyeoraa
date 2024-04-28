//
//  LocationManagerProtocol.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/28/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import MapKit
import RxRelay
import RxSwift

public protocol LocationManagerProtocol: AnyObject {
    // MARK: Methods
    func setSearchText(with searchText: String) -> Observable<[Address]> 
    func fetchCurrentLocation() -> Result<Coordinate, Error>
}
