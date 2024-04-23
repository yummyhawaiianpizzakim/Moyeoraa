//
//  SignUpUseCaseImpl.swift
//  AuthUseCase
//
//  Created by 김요한 on 2024/04/21.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import RxSwift

public final class SignUpUseCaseImpl: SignUpUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    public init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    public func signUp(name: String, profileImage: String?) -> Observable<Void> {
        let tagNumber = self.generateTagNumber()
        return self.authRepository.createUser(name: name, profileURL: profileImage, tagNumber: tagNumber)
    }
    
    private func generateTagNumber() -> Int {
        return Int.random(in: 1000...9999)
    }
}
