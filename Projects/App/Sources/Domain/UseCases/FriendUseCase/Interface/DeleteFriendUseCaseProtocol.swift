//
//  DeleteFriendUseCaseProtocol.swift
//  FriendUseCaseInterface
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public protocol DeleteFriendUseCaseProtocol: AnyObject {
    func delete(_ id: String) -> Observable<Void>
    func delete(friendID: String) -> Observable<Void> 
}
