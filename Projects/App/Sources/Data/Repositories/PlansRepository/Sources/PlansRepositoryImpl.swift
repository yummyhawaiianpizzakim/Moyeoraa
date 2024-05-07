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
            date: date.toStringWithCustomFormat(.yearToMinute, locale: .current),
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
    
    public func fetchPlans(id: String) -> Observable<Plans> {
        self.firebaseService.getDocument(collection: .plans, document: id)
            .compactMap({ $0.toObject(PlansDTO.self)?.toEntity() })
            .asObservable()
    }
    
    public func fetchPlans(chatRoomID: String) -> Observable<Plans> {
        self.firebaseService.getDocument(collection: .plans, field: "chatRoomID", in: [chatRoomID])
            .map({ $0.compactMap { $0.toObject(PlansDTO.self)?.toEntity() } })
            .compactMap({ $0.last })
            .asObservable()
    }
    
    public func deletePlans(id: String) -> Observable<Void> {
        self.firebaseService.deleteDocument(collection: .plans, document: id)
            .asObservable()
    }
    
    public func updatePlans(id: String, title: String, date: Date, location: Address, members: [User]) -> Observable<Void> {
        let dateString = date.toStringWithCustomFormat(.yearToMinute)
        var values: [String : Any] = [
            "title": title,
            "date": dateString,
            "latitude":location.lat,
            "longitude":location.lng,
            "location":location.name,
            "usersID": members.map({ $0.id }),
        ]
        
        return self.firebaseService
            .updateDocument(collection: .plans, document: id, values: values)
            .asObservable()
    }
    
    public func updatePlans(id: String, usersID: [String]) -> Observable<Void> {
        var values: [String : Any] = [
            "usersID": usersID
        ]
        
        return self.firebaseService
            .updateDocument(collection: .plans, document: id, values: values)
            .asObservable()
    }
}
