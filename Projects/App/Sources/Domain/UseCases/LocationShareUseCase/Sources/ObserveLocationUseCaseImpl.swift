//
//  ObserveLocationUseCaseImpl.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/29.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class ObserveLocationUseCaseImpl: ObserveLocationUseCaseProtocol {
    private let locationRepository: LocationRepositoryProtocol
    
    public init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    public func observe(chatroomID: String) -> Observable<[SharedLocation]> {
        return self.locationRepository.observe(chatRoomID: chatroomID)
    }
    
    public func removeObserve() -> Observable<Void> {
        return self.locationRepository.removeObserve()
    }
}
