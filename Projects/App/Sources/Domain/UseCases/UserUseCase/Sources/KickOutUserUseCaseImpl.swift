//
//  KickOutUserUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/2/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class KickOutUserUseCaseImpl: KickOutUserUseCaseProtocol {
    private let plansRepository: PlansRepositoryProtocol
    
    public init(plansRepository: PlansRepositoryProtocol) {
        self.plansRepository = plansRepository
    }
    
    public func kickOut(plansID: String, usersID: [String]) -> Observable<Void> {
        self.plansRepository.updatePlans(id: plansID, usersID: usersID)
    }
}
