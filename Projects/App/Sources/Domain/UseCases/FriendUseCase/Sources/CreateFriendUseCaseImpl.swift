//
//  CreateFriendUseCaseImpl.swift
//  FriendUseCaseInterface
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//
import RxSwift

public final class CreateFriendUseCaseImpl: CreateFriendUseCaseProtocol {
    private let friendRepository: FriendRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    public init(friendRepository: FriendRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        self.friendRepository = friendRepository
        self.userRepository = userRepository
    }
    
    public func create(_ friendID: String) -> Observable<Void> {
        self.userRepository.getUserInfo(friendID)
            .withUnretained(self)
            .flatMap { owner, user in
                owner.friendRepository.createFriend(userInfo: user)
            }
    }
    
}
