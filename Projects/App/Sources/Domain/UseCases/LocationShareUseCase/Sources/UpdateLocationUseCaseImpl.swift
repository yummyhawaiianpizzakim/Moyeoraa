//
//  UpdateLocationUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/4/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class UpdateLocationUseCaseImpl: UpdateLocationUseCaseProtocol {
    private let locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    public func update(chatRoomID: String, coordinate: Coordinate, isArrived: Bool) -> Observable<Void> {
        self.locationRepository.updateLocation(chatRoomID: chatRoomID, coordinate: coordinate, isArrived: isArrived)
    }
}
