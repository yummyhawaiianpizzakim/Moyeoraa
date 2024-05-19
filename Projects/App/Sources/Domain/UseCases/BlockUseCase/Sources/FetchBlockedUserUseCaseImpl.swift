//
//  FetchBlockedUserUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/1/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class FetchBlockedUserUseCaseImpl: FetchBlockedUserUseCaseProtocol {
    private let blockRepository: BlockRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    init(blockRepository: BlockRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        self.blockRepository = blockRepository
        self.userRepository = userRepository
    }
    
    public func fetch() -> Observable<[Block.BlockedUser]> {
        return self.blockRepository.fetchBlocks()
            .withUnretained(self)
            .flatMap { owner, blocks in
                let userIDs = blocks.map { $0.blockedUserId }
                return owner.userRepository.getUsersInfo(userIDs)
                    .map { users in
                        owner.mapBlockedUsers(blocks: blocks, users: users)
                    }
            }
    }
}

private extension FetchBlockedUserUseCaseImpl {
    func mapBlockedUsers(blocks: [Block], users: [User]) -> [Block.BlockedUser] {
        var blockedUsers: [Block.BlockedUser] = []
        
        let blocksDict = Dictionary(uniqueKeysWithValues: blocks.map({ ($0.blockedUserId, $0) }))
        
        let usersDict = Dictionary(uniqueKeysWithValues: users.map({ ($0.id, $0) }))
        
        for (id, block) in blocksDict {
            guard let user = usersDict[id] else { return [] }
            let blockedUser = Block.BlockedUser(blockId: block.blockId, blockedUser: user)
            blockedUsers.append(blockedUser)
        }
        
        return blockedUsers
    }
}
