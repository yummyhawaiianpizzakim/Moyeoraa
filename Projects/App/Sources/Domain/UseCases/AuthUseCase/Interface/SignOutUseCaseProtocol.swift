//
//  SignOutUseCaseProtocol.swift
//  AuthUseCaseInterface
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol SignOutUseCaseProtocol: AnyObject {
    func signOut() -> Observable<Void>
}
