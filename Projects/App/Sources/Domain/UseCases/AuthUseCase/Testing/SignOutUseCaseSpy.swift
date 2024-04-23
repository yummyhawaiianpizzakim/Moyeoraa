//
//  SignOutUseCaseSpy.swift
//  AuthUseCaseInterface
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class SignOutUseCaseSpy: SignOutUseCaseProtocol {
    public init() { }
    public func signOut() -> Observable<Void> {
        print("signOut")
        return Observable.just(())
    }
}
