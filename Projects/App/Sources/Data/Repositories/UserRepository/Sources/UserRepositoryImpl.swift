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
        return Observable.just([])
    }
    
    
}
