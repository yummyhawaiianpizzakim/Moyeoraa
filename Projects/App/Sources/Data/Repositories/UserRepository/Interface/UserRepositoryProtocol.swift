//
//  UserRepositoryProtocol.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserRepositoryProtocol: AnyObject {
    func getUserInfo() -> Observable<User>
    func getUserInfo(_ id: String) -> Observable<User>
    func getUsersInfo(_ ids: [String]) -> Observable<[User]>
}
