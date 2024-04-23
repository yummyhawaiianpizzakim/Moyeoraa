//
//  FetchFriendsUseCaseProtocol.swift
//  FriendUseCaseInterface
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public protocol FetchFriendsUseCaseProtocol: AnyObject {
    func fetch() -> Observable<[Friend]>
}
