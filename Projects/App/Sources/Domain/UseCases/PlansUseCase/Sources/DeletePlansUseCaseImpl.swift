//
//  DeletePlansUseCaseImpl.swift
//  PlansUseCaseInterface
//
//  Created by 김요한 on 2024/04/12.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class DeletePlansUseCaseImpl: DeletePlansUseCaseProtocol {
    private let plansRepository: PlansRepositoryProtocol
    
    public init(plansRepository: PlansRepositoryProtocol) {
        self.plansRepository = plansRepository
    }
    
    public func delete(plansID: String) -> Observable<Void> {
        self.plansRepository.deletePlans(id: plansID)
    }
}
