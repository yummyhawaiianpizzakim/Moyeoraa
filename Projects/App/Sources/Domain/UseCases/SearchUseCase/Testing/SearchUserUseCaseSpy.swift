//
//  SearchUserUseCaseSpy.swift
//  SearchUseCaseInterface
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class SearchUserUseCaseSpy: SearchUserUseCaseProtocol {
    public init() {
        
    }
    
    public func search(text: String) -> Observable<[User]> {
        let textTOInt = Int(text)
        let users1 = searchUserName(name: text)
        
        let users2 = searchUserTag(number: textTOInt)
        
        return Observable.just(users1 + users2)
    }
    
    private func getUsers() -> [User] {
        let user1 = User(id: "qwer", name: "qqqqqweqweqwe", tagNumber: 1234, fcmToken: "", isNotification: false)
        
        let user2 = User(id: "asdf", name: "wwwwasdasfsg", tagNumber: 5678, fcmToken: "", isNotification: false)
        
        let user3 = User(id: "zxcv", name: "eeeezxcxcbxcbz", tagNumber: 1357, fcmToken: "", isNotification: false)
        
        return [user1, user2, user3]
    }
    
    private func searchUserName(name: String) -> [User] {
        let users = self.getUsers()
        
        return users.filter { user in
            user.name == name ?
            true : false
        }
    }
    
    private func searchUserTag(number: Int?) -> [User] {
        guard let number else { return [] }
        let users = self.getUsers()
        
        return users.filter { user in
            user.tagNumber == number ?
            true : false
        }
    }
    
    
}
