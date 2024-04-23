//
//  FetchBlockedUserUseCaseSpy.swift
//  BlockUseCase
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class FetchBlockedUserUseCaseSpy: FetchBlockedUserUseCaseProtocol {
    
    public init() {
        
    }
    
    public func fetch() -> Observable<[Block.BlockedUser]> {
        let users = self.getUsers()
        
        return Observable.just(users)
    }
    
    private func getUsers() -> [Block.BlockedUser] {
        let user1 = User(id: "qwer", name: "qqqq", tagNumber: 1234, fcmToken: "", isNotification: false)
        
        let user2 = User(id: "asdf", name: "wwww", tagNumber: 5678, fcmToken: "", isNotification: false)
        
        let user3 = User(id: "zxcv", name: "eeee", tagNumber: 1357, fcmToken: "", isNotification: false)
        
        let block1 = Block.BlockedUser(blockId: "yuio", blockedUser: user1)
        
        let block2 = Block.BlockedUser(blockId: "ghjk", blockedUser: user2)
        
        let block3 = Block.BlockedUser(blockId: "bnmv", blockedUser: user3)
        
        return [block1, block2, block3]
    }
    
}
