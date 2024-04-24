//
//  PlansRepositoryImpl.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class PlansRepositoryImpl: PlansRepositoryProtocol {
    private let firebaseService: FireBaseServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    public init(firebaseService: FireBaseServiceProtocol,
                tokenManager: TokenManagerProtocol) {
        self.firebaseService = firebaseService
        self.tokenManager = tokenManager
    }
    
    public func createPlans(plansID: String,
                            makingUser: User,
                            title: String,
                            date: Date,
                            location: Address,
                            membersID: [String],
                            chatRoomID: String) -> Observable<Void> {
        
        let dto = PlansDTO(
            id: plansID,
            title: title,
            date: date.toStringWithCustomFormat("yyyy. MM. dd HH:mm", locale: .current),
            location: location.name,
            latitude: location.lat,
            longitude: location.lng,
            makingUserID: makingUser.id,
            usersID: membersID,
            chatRoomID: chatRoomID,
            status: .active
        )
        
        guard let values = dto.asDictionary else { return .error(FireStoreError.unknown) }
        
        return self.firebaseService
            .createDocument(
                collection: .plans,
                document: plansID,
                values: values
            )
            .asObservable()
    }
    
}
