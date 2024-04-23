//
//  FetchUserUseCaseProtocol.swift
//  UserUseCaseInterface
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol FetchUserUseCaseProtocol: AnyObject {
    func fetch() -> Observable<User>
    
    func fetch(userIDs: [String]) -> Observable<[User]>
}
