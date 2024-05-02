//
//  UserRepositoryImpl.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class UserRepositoryImpl: UserRepositoryProtocol {
    
    private let firebaseService: FireBaseServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    public init(firebaseService: FireBaseServiceProtocol,
                tokenManager: TokenManagerProtocol) {
        self.firebaseService = firebaseService
        self.tokenManager = tokenManager
    }
    
    public func getUserInfo() -> Observable<User> {
        guard let id = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        
        return self.getUserInfo(id)
    }
    
    public func getUserInfo(_ id: String) -> Observable<User> {
        self.firebaseService
            .getDocument(collection: .users, document: id)
            .compactMap { $0.toObject(UserDTO.self)?.toEntity() }
            .asObservable()
    }
    
    
    public func getUsersInfo(_ ids: [String]) -> Observable<[User]> {
        return self.firebaseService
            .getDocument(collection: .users, field: "id", in: ids)
            .map { $0.compactMap { $0.toObject(UserDTO.self)?.toEntity() } }
            .asObservable()
    }
    
    public func getUsersInfo(_ keyword: String) -> Observable<[User]> {
        let myID = self.tokenManager.getToken(with: .userId)
        print("keyword:: \(keyword)")
        let usersByName = self.searchUsers(byName: keyword)
        let usersByTag = self.searchUsers(byTagNumber: keyword)
        
        return Observable.combineLatest(usersByName, usersByTag)
            .map({ val -> [User] in
                let (usersByName, usersByTag) = val
                var arr: [User] = []
                arr.append(contentsOf: usersByTag)
                arr.append(contentsOf: usersByName)
                return arr
            })
            .map { $0.filter { $0.id != myID } }
            .map { $0.removingDuplicates() }
    }
    
    public func updateUserInfo(imageURL: String?, name: String) -> Observable<Void> {
        guard let id = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        
        var values: [String: Any] = [:]
        
        if let imageURL {
            values.updateValue(imageURL, forKey: "profileImage")
        }
        
        values.updateValue(name, forKey: "name")
        
        return self.firebaseService
            .updateDocument(collection: .users, document: id, values: values)
            .asObservable()
    }
}

private extension UserRepositoryImpl {
    func searchUsers(byName name: String) -> Observable<[User]> {
        self.firebaseService.getDocument(collection: .users, field: "name", keyword: name)
//            .debug("searchUsersByName")
            .map({ $0.compactMap { $0.toObject(UserDTO.self)?.toEntity() } })
            .asObservable()
    }
    
    func searchUsers(byTagNumber tagNumber: String) -> Observable<[User]> {
        self.firebaseService.getDocument(collection: .users, field: "tagNumber", keyword: tagNumber)
//            .debug("searchUsersByTagNumber")
            .map({ $0.compactMap { $0.toObject(UserDTO.self)?.toEntity() } })
            .asObservable()
    }
}
