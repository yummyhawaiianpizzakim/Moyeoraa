//
//  CheckLocationShareEnableUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/15/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class CheckLocationShareEnableUseCaseImpl: CheckLocationShareEnableUseCaseProtocol {
    private let plansRepository: PlansRepositoryProtocol
    
    public init(plansRepository: PlansRepositoryProtocol) {
        self.plansRepository = plansRepository
    }
    
    public func check(plansID: String) -> Observable<Bool> {
        self.plansRepository.fetchPlans(id: plansID)
            .withUnretained(self)
            .map { owner, plans in
                owner.checkIsToday(plansDate: plans.date)
            }
    }
}

private extension CheckLocationShareEnableUseCaseImpl {
    func checkIsToday(plansDate: Date) -> Bool {
        guard let timeZone = TimeZone(identifier: "Asia/Seoul") else { return false }
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        print(calendar)
        // 오늘 날짜와 약속 날짜를 비교합니다.
        return calendar.isDateInToday(plansDate)
    }
}
