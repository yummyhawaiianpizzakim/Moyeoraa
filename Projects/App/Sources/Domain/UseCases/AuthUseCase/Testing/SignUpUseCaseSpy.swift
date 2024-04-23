//
//  SignUpUseCaseSpy.swift
//  AuthUseCaseTesting
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class SignUpUseCaseSpy: SignUpUseCaseProtocol {
    public init() {
        
    }
    
    public func signUp(name: String, profileImage: String?) -> Observable<Void> {
        return Observable.just(())
    }
}
