//
//  FetchPlansUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/29/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class FetchPlansUseCaseImpl: FetchPlansUseCaseProtocol {
    private let plansRepository: PlansRepositoryProtocol
    
    public init(plansRepository: PlansRepositoryProtocol) {
        self.plansRepository = plansRepository
    }
    
    public func fetch(date: Observable<Date>) -> Observable<[Plans]> {
        return date.withUnretained(self).flatMap { owner, date -> Observable<[Plans]> in
            owner.plansRepository.fetchPlansArr(date: date)
                .map { $0.sorted { $0.date > $1.date } }
        }
    }
    
    public func fetch(id: String) -> Observable<Plans> {
        self.plansRepository.fetchPlans(id: id)
    }
    
    public func fetch(chatRoomID: String) -> Observable<Plans> {
        self.plansRepository.fetchPlans(chatRoomID: chatRoomID)
    }
    
    public func fetch() -> Observable<[Plans]> {
        self.plansRepository.fetchPlansArr()
    }
}

