//
//  ImageRepositoryImpl.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class ImageRepositoryImpl: ImageRepositoryProtocol {
    private let fireBaseService: FireBaseServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    init(fireBaseService: FireBaseServiceProtocol, tokenManager: TokenManagerProtocol) {
        self.fireBaseService = fireBaseService
        self.tokenManager = tokenManager
    }
    
    public func uploadImage(imageData: Data) -> Observable<String> {
        self.fireBaseService.uploadImage(imageData: imageData)
            .asObservable()
    }
    
    public func deleteImage(imageString: String) -> Observable<Void> {
        guard let path = imageString.extractFilePath() else { return .error(LocalError.transformType) }
        return self.fireBaseService.deleteImage(path: path)
            .asObservable()
    }
    
    public func deleteMyProfileImage() -> Observable<Void> {
        guard let id = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        
//        return self.fireBaseService.getDocument(collection: .users, document: id)
//            .asObservable()
//            .map { $0.toObject(UserDTO.self)?.toEntity() }
//            .compactMap { $0?.profileImage }
//            .withUnretained(self)
//            .flatMap { owner, imageString in
//                owner.deleteImage(imageString: imageString)
//            }
//            .catchAndReturn(())
        
        return self.fireBaseService
            .getDocument(collection: .users, document: id)
            .asObservable()
            .map { $0.toObject(UserDTO.self)?.toEntity() }
            .flatMap { user -> Observable<Void> in
                guard let profileImage = user?.profileImage else {
                    return .just(())
                }
                return self.deleteImage(imageString: profileImage)
                    .catchAndReturn(())
            }
    }
}
