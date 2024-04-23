//
//  FetchUserUseCaseSpy.swift
//  UserUseCaseInterface
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class FetchUserUseCaseSpy: FetchUserUseCaseProtocol {
    
    public init() { }
    
    public func fetch() -> Observable<User> {
        let user = User(id: "1234", name: "dkemrmf", tagNumber: 1234, fcmToken: "zxcv", isNotification: true)
        return Observable.just(user)
    }
    
    public func fetch(userIDs: [String]) -> Observable<[User]> {
        let users = self.getUsers()
        
        let filtered = users.filter { user in
            userIDs.contains { id in
                id == user.id
            }
        }
        
        return Observable.just(filtered)
    }
    
    private func getUsers() -> [User] {
        let user1 = User(id: "qwer", name: "qqqqqweqweqwe", tagNumber: 1234, fcmToken: "", isNotification: false)
        
        let user2 = User(id: "asdf", name: "wwwwasdasfsg", tagNumber: 5678, fcmToken: "", isNotification: false)
        
        let user3 = User(id: "zxcv", name: "eeeezxcxcbxcbz", tagNumber: 1357, fcmToken: "", isNotification: false)
        
        return [user1, user2, user3]
    }
}
