//
//  UpdatePlansUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/2/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class UpdatePlansUseCaseImpl: UpdatePlansUseCaseProtocol {
    private let plansRepository: PlansRepositoryProtocol
    
    init(plansRepository: PlansRepositoryProtocol) {
        self.plansRepository = plansRepository
    }
    
    public func update(id: String, title: String, date: Date, location: Address, members: [User]) -> Observable<Void> {
        self.plansRepository.updatePlans(id: id, title: title, date: date, location: location, members: members)
    }
    
    
}
