//
//  DeleteFriendUseCaseImpl.swift
//  FriendUseCaseInterface
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class DeleteFriendUseCaseImpl: DeleteFriendUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol
    private let friendRepository: FriendRepositoryProtocol
    
    public init(userRepository: UserRepositoryProtocol, friendRepository: FriendRepositoryProtocol) {
        self.userRepository = userRepository
        self.friendRepository = friendRepository
    }
    
    public func delete(_ id: String) -> Observable<Void> {
        self.userRepository.getUserInfo(id)
            .withUnretained(self)
            .flatMap { owner, user in
                owner.friendRepository.deleteFriend(userInfo: user)
            }
    }
    
    public func delete(friendID: String) -> Observable<Void> {
        self.friendRepository.deleteFriend(friendID: friendID)
    }
    
}
