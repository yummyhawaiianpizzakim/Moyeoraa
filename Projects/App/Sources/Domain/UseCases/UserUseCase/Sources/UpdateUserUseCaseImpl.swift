//
//  UpdateUserUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/30/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class UpdateUserUseCaseImpl: UpdateUserUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    public func update(profileURL: String?, name: String) -> Observable<Void> {
        return self.userRepository.updateUserInfo(imageURL: profileURL, name: name)
    }
}
