//
//  SearchUserUseCaseImpl.swift
//  SearchUseCaseInterface
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class SearchUserUseCaseImpl: SearchUserUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol
    
    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    public func search(text: String) -> Observable<[User]> {
        self.userRepository.getUsersInfo(text)
    }
}
