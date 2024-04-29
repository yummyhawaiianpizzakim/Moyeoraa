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
        let plans = Plans(id: "1234", title: "스벅에서 만나기", date: Date(), location: "대연동 스벅", latitude: 0, longitude: 0, makingUserID: "qwer", usersID: ["qwer", "asdf", "zxcv"], chatRoomID: "zxcv", status: .active)
        
        return Observable.just(plans)
    }
    
}

