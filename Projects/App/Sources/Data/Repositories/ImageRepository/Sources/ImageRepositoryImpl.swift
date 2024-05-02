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
}
