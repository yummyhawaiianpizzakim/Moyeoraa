//
//  SignInUseCaseProtocol.swift
//  AuthUseCaseInterface
//
//  Created by 김요한 on 2024/04/15.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol SignInUseCaseProtocol {

    // MARK: - Methods
    func checkRegistration(uid: String) -> Observable<Bool>
    func updateFcmToken() -> Observable<Void>
}
