//
//  SignInUseCaseImpl.swift
//  AuthUseCase
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class SignInUseCaseImpl: SignInUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    public init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    public func checkRegistration(uid: String) -> Observable<Bool> {
        self.authRepository.checkUser(uid: uid).asObservable()
    }
    
    public func updateFcmToken() -> Observable<Void> {
        self.authRepository.updateFcmToken()
    }
}
