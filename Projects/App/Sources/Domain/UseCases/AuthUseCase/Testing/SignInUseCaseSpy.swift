//
//  SignInUseCaseSpy.swift
//  AuthUseCaseInterface
//
//  Created by 김요한 on 2024/04/15.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class SignInUseCaseSpy: SignInUseCaseProtocol {

    public init() {

    }
    
    public func checkRegistration(uid: String) -> Observable<Bool> {
        Observable.just(false)
    }
    
    public func autoSignIn() -> Observable<Bool> {
        return Observable.just(true)
    }

    public func updateFcmToken() -> Observable<Void> {
        return Observable.just(())
    }
}
