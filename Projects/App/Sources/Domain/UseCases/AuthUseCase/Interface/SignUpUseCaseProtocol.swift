//
//  SignUpUseCaseProtocol.swift
//  AuthUseCaseInterface
//
//  Created by 김요한 on 2024/04/15.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public protocol SignUpUseCaseProtocol: AnyObject {
    func signUp(name: String, profileImage: String?) -> Observable<Void>
}
