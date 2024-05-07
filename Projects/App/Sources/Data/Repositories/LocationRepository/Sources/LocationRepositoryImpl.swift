//
//  LocationRepositoryImpl.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class LocationRepositoryImpl: LocationRepositoryProtocol {
    private let firebaseService: FireBaseServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    public init(firebaseService: FireBaseServiceProtocol,
                tokenManager: TokenManagerProtocol) {
        self.firebaseService = firebaseService
        self.tokenManager = tokenManager
    }
    
    public func updateLocation(chatRoomID: String, coordinate: Coordinate) -> Observable<Void> {
        guard let userID = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        let sharedLocation = SharedLocation(userID: userID, latitude: coordinate.lat, longitude: coordinate.lng)
        
        guard let values = sharedLocation.asDictionary else {
            return .error(FireStoreError.unknown)
        }
        
        return self.firebaseService
            .createDocument(
                documents: ["chatrooms", chatRoomID, "locations", userID],
                values: values)
            .asObservable()
    }
    
    public func observe(chatRoomID: String) -> Observable<[SharedLocation]> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.firebaseService
            .observeSharedLocation(documents: ["chatrooms", chatRoomID, "locations"])
            .map { $0.compactMap { $0.toObject(SharedLocation.self) } }
            .asObservable()
//            .debug("observeLocation")
        }
    
    public func removeObserve() -> Observable<Void> {
        guard let userID = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.firebaseService
            .removeSharedLocationObserve()
            .asObservable()
    }
    
    public func completeShare(chatroomId: String) -> Observable<Void> {
        guard let userID = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        return self.firebaseService
            .deleteDocument(documents: ["chatrooms", chatroomId, "locations", userID])
            .asObservable()
//            .debug("completeLocation")
    }
}
