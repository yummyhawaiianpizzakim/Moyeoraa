//
//  AuthRepositoryImpl.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import RxSwift
import FirebaseAuth

public final class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let firebaseService: FireBaseServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    public init(firebaseService: FireBaseServiceProtocol,
                tokenManager: TokenManagerProtocol) {
        self.firebaseService = firebaseService
        self.tokenManager = tokenManager
    }
    
    public func checkUser(uid: String) -> Single<Bool> {
        self.tokenManager.save(token: uid, with: .userId)
        print("checkUser(uid:: \(uid)")
        return self.firebaseService.getDocument(
            collection: .users,
            field: "id",
            in: [uid]
        )
        .map { !$0.isEmpty }
    }
    
    public func createUser(name: String, profileURL: String?, tagNumber: Int) -> Observable<Void> {
        guard let userID = self.tokenManager.getToken(with: .userId),
              let fcmToken = self.tokenManager.getToken(with: .fcmToken)
        else { return .error(RxError.unknown) }
        let tagNumber = String(tagNumber)
        let userDTO = UserDTO(
            id: userID,
            name: name,
            tagNumber: tagNumber,
            profileImage: profileURL,
            fcmToken: fcmToken
        )
        
        guard let values = userDTO.asDictionary else {
            return .error(RxError.unknown)
        }
        
        return self.firebaseService.createDocument(
            collection: .users,
            document: userDTO.id,
            values: values
        )
        .asObservable()
        .debug("createDocument")
    }
    
    public func updateFcmToken() -> Observable<Void> {
        guard
            let userID = tokenManager.getToken(with: .userId),
            let fcmToken = tokenManager.getToken(with: .fcmToken)
        else {
            return .error(RxError.unknown)
        }
        
        let values = ["fcmToken": fcmToken]
        print("userID \(userID) fcmToken \(fcmToken)")
        
        return self.firebaseService.updateDocument(
            collection: .users,
            document: userID,
            values: values
        )
        .asObservable()
        .debug("updateFcmToken")
    }
    
    public func signOut() -> Observable<Void> {
        return Observable.create { [weak self] observable in
            guard let self else { return Disposables.create() }
            
            do {
                try Auth.auth().signOut()
                self.tokenManager.deleteToken(with: .userId)
                observable.onNext(())
                observable.onCompleted()
            } catch let error {
                observable.onError(error)
                observable.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    public func dropOut() -> Single<Void> {
        guard let user = Auth.auth().currentUser 
        else { return .error(FireStoreError.unknown) }
        
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            user.delete { error in
                if let error {
                    single(.failure(error))
                    return
                }
                
                if self.tokenManager.deleteToken(with: .userId) && self.tokenManager.deleteToken(with: .fcmToken) {
                    single(.success(()))
                } else {
                    single(.failure(FireStoreError.unknown))
                }
            }
            
            return Disposables.create()
        }
    }
}
