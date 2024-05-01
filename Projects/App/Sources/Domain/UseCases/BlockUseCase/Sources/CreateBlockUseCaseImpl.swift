//
//  CreateBlockUseCaseImpl.swift
//  BlockUseCaseInterface
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class CreateBlockUseCaseImpl: CreateBlockUseCaseProtocol {
    private let blockRepository: BlockRepositoryProtocol
    
    public init(blockRepository: BlockRepositoryProtocol) {
        self.blockRepository = blockRepository
    }
    
    
    public func create(_ userID: String) -> Observable<Void> {
        self.blockRepository.createBlockUser(userID: userID)
    }
    
}
