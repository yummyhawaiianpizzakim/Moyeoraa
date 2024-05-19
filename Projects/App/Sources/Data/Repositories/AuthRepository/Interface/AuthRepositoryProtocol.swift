//
//  AuthRepositoryProtocol.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import RxSwift

public protocol AuthRepositoryProtocol {
    func checkUser(uid: String) -> Single<Bool>
    func createUser(name: String, profileURL: String?, tagNumber: Int) -> Observable<Void>
    func updateFcmToken() -> Observable<Void> 
    func signOut() -> Observable<Void> 
    func dropOut() -> Single<Void> 
}
