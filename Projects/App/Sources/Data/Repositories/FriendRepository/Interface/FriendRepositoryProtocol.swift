//
//  FriendRepositoryProtocol.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/28/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol FriendRepositoryProtocol: AnyObject {
    func fetchFriends() -> Observable<[Friend]>
    func createFriend(userInfo: User) -> Observable<Void> 
    func deleteFriend(userInfo: User) -> Observable<Void> 
}
