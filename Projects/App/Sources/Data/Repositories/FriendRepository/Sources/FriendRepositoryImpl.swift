//
//  FriendRepositoryImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/28/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class FriendRepositoryImpl: FriendRepositoryProtocol {
    private let fireBaseService: FireBaseServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    public init(fireBaseService: FireBaseServiceProtocol, tokenManager: TokenManagerProtocol) {
        self.fireBaseService = fireBaseService
        self.tokenManager = tokenManager
    }
    
    public func fetchFriends() -> Observable<[Friend]> {
        guard let userID = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        
        return self.fireBaseService.getDocument(collection: .users, documents: [userID] + ["friends"])
            .debug("fetchFriends::")
            .map { $0.compactMap({ $0.toObject(FriendDTO.self)?.toEntity() }) }
            .asObservable()
    }
    
    public func createFriend(userInfo: User) -> Observable<Void> {
        guard let myID = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        
        let tagNumber = String(userInfo.tagNumber)
        
        let dto = FriendDTO(
            id: UUID().uuidString,
            name: userInfo.name,
            tagNumber: tagNumber,
            prfileImage: userInfo.profileImage,
            followingUserID: myID,
            userID: userInfo.id
        )
        
        guard let values = dto.asDictionary else { return .error(LocalError.structToDictionaryError) }
        
        return self.fireBaseService
            .createDocument(documents: ["users", myID, "friends", dto.id], values: values)
            .debug("createFriend")
            .asObservable()
    }
    
    public func deleteFriend(userInfo: User) -> Observable<Void> {
        guard let myID = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        return self.fetchFriend(userInfo.id)
            .debug("fetchFriend")
            .flatMap {
                self.fireBaseService
                    .deleteDocument(collectionPaths: ["users", myID, "friends"], document: $0.id)
                    .debug("deleteFriend")
            }
    }
    
    public func deleteFriend(friendID: String) -> Observable<Void> {
        guard let myID = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        return self.fireBaseService.deleteDocument(collectionPaths: ["users", myID, "friends"], document: friendID)
            .asObservable()
    }
}

private extension FriendRepositoryImpl {
    func fetchFriend(_ id: String) -> Observable<Friend> {
        guard let myID = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        
        return self.fireBaseService
            .getDocument(collectionPaths: ["users", myID, "friends"], field: "userID", in: [id])
//            .asObservable()
            .map { $0.compactMap({ $0.toObject(FriendDTO.self)?.toEntity() }) }
            .compactMap({ $0.last })
            .asObservable()
    }
}
