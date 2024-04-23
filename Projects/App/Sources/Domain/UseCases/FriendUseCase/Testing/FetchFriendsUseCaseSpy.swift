//
//  FetchFriendsUseCaseSpy.swift
//  FriendUseCaseInterface
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class FetchFriendsUseCaseSpy: FetchFriendsUseCaseProtocol {
    
    public init() {
        
    }
    
    public func fetch() -> Observable<[Friend]> {
        let friends = self.getFriends()
        
        return Observable.just(friends)
    }
    
    private func getFriends() -> [Friend] {
        let userID = "1234"
        
        if userID == "1234" {
            let friend1 = Friend(id: "qwer", name: "qqqq", tagNumber: 1234, prfileImage: nil, followingUserID: "1234", userID: "qwer")
            
            let friend2 = Friend(id: "asdf", name: "wwww", tagNumber: 5678, prfileImage: nil, followingUserID: "1234", userID: "1653")
            
            let friend3 = Friend(id: "zxcv", name: "eeee", tagNumber: 1357, prfileImage: nil, followingUserID: "1234", userID: "zxcv")
            
            return [friend1, friend2, friend3]
        }
        
        return []
    }
}
