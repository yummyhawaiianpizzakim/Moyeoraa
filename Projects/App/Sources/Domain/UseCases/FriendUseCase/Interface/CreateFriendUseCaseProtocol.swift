//
//  CreateFriendUseCaseProtocol.swift
//  FriendUseCaseInterface
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol CreateFriendUseCaseProtocol {
    func create(_ friendID: String) -> Observable<Void> 
}
