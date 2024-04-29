//
//  FetchFriendsUseCaseImpl.swift
//  FriendUseCaseInterface
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class FetchFriendsUseCaseImpl: FetchFriendsUseCaseProtocol {
    private let friendRepository: FriendRepositoryProtocol
    
    public init(friendRepository: FriendRepositoryProtocol) {
        self.friendRepository = friendRepository
    }
    
    public func fetch() -> Observable<[Friend]> {
        return self.friendRepository.fetchFriends()
    }
}
