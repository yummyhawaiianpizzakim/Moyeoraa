//
//  DeleteBlockUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/1/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class DeleteBlockUseCaseImpl: DeleteBlockUseCaseProtocol {
    private let blockRepository: BlockRepositoryProtocol
    
    init(blockRepository: BlockRepositoryProtocol) {
        self.blockRepository = blockRepository
    }
    
    public func delete(_ id: String) -> Observable<Void> {
        self.blockRepository.deleteBlockUser(userID: id)
    }
}
