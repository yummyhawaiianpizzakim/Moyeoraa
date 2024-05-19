//
//  ExitChatRoomUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/12/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class ExitChatRoomUseCaseImpl: ExitChatRoomUseCaseProtocol {
    private let plansRepository: PlansRepositoryProtocol
    
    public init(plansRepository: PlansRepositoryProtocol) {
        self.plansRepository = plansRepository
    }
    
    public func exit(plansID: String) -> Observable<Void> {
        self.plansRepository.fetchPlans(id: plansID)
            .withUnretained(self)
            .flatMap { owner, plans in
                owner.plansRepository.updatePlans(id: plans.id, usersID: plans.usersID)
            }
    }
}
