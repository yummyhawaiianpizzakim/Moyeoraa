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
            date: date.toStringWithCustomFormat(.hourAndMinute, locale: .current),
            location: location.name,
            latitude: location.lat,
            longitude: location.lng,
            makingUserID: makingUser.id,
            usersID: membersID + [makingUser.id],
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
    
    
    public func fetchPlansArr() -> Observable<[Plans]> {
        guard let userID = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound)}
        
        return self.firebaseService
            .getDocument(
                collection: .plans,
                field: "usersID",
                arrayContainsAny: [userID]
            )
            .asObservable()
            .map { 
                $0.compactMap { $0.toObject(PlansDTO.self)?.toEntity() }
            }
    }
    
    public func fetchPlansArr(date: Date) -> Observable<[Plans]> {
        let date = date.toStringWithCustomFormat(.yearToDay)
        
        return self.firebaseService.getDocument(collection: .plans, field: "date", keyword: date)
//            .debug("fetchPlansArr(date: ")
            .map { $0.compactMap { $0.toObject(PlansDTO.self)?.toEntity() } }
            .asObservable()
    }
}
