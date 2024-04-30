//
//  FetchUserUseCaseImpl.swift
//  UserUseCaseInterface
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class FetchUserUseCaseImpl: FetchUserUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol
    
    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    public func fetch() -> Observable<User> {
        let user = User(id: "1234", name: "dkemrmf", tagNumber: 1234, fcmToken: "zxcv", isNotification: true)
        return Observable.just(user)
    }
    
    public func fetch(userIDs: [String]) -> Observable<[User]> {
        self.userRepository.getUsersInfo(userIDs)
    }
    
}
