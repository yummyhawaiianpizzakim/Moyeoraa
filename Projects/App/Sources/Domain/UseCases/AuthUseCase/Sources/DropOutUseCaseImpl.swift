//
//  DropOutUseCaseImpl.swift
//  AuthUseCaseInterface
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class DropOutUseCaseImpl: DropOutUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let plansRepository: PlansRepositoryProtocol
    private let friendRepository: FriendRepositoryProtocol
    
    public init(authRepository: AuthRepositoryProtocol, userRepository: UserRepositoryProtocol, plansRepository: PlansRepositoryProtocol, friendRepository: FriendRepositoryProtocol) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.plansRepository = plansRepository
        self.friendRepository = friendRepository
    }
    
    public func dropOut() -> Observable<Void> {
        return self.friendRepository.deleteFriendsWhenDeleteUserInfo()
            .asObservable()
            .withUnretained(self)
            .flatMap({ owner, _ in
                owner.userRepository.deleteUserInfo()
            })
            .withUnretained(self)
            .flatMap({ owner, _ in
                owner.plansRepository.updatePlansWhenDeleteUserInfo()
            })
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.authRepository.dropOut()
            }
    }
}
