//
//  MapRepositoryImpl.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class MapRepositoryImpl: MapRepositoryProtocol {
    private let locationManager: LocationManagerProtocol
    
    public init(locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
    }
    
    public func searchAddress(_ text: String) -> Observable<[Address]> {
        self.locationManager.setSearchText(with: text)
    }
}
