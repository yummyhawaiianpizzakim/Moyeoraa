//
//  EndLocationShareUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/6/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class EndLocationShareUseCaseImpl: EndLocationShareUseCaseProtocol {
    private let locationRepository: LocationRepositoryProtocol
    
    public init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    public func complete(chatRoomID: String) -> Observable<Void> {
        self.locationRepository.completeShare(chatroomId: chatRoomID)
    }
}
