//
//  FetchPlansUseCaseSpy.swift
//  PlansUseCaseInterface
//
//  Created by 김요한 on 2024/03/28.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class FetchPlansUseCaseSpy: FetchPlansUseCaseProtocol {
    
    public init() {
        
    }
    
    public func fetch(date: Observable<Date>) -> Observable<[Plans]> {
        let plansArray = self.createSampleDate()
        
        let resultPlans = date.withUnretained(self)
            .map { owner, date in
            owner.filterPlansForSelectedDate(plansArray: plansArray, selectedDate: date)
        }
        
        return resultPlans
    }
    
    public func fetch(id: String) -> Observable<Plans> {
        let plans = Plans(id: "1234", title: "스벅에서 만나기", date: Date(), location: "대연동 스벅", latitude: 0, longitude: 0, makingUserID: "qwer", usersID: ["qwer", "asdf", "zxcv"], chatRoomID: "zxcv", status: .active)
        
        return Observable.just(plans)
    }
    
    public func fetch(chatRoomID: String) -> Observable<Plans> {
        let plans = Plans(id: "1234", title: "스벅에서 만나기", date: Date(), location: "대연동 스벅", latitude: 0, longitude: 0, makingUserID: "qwer", usersID: ["qwer", "asdf", "zxcv"], chatRoomID: "zxcv", status: .active)
        
        return Observable.just(plans)
    }
    
    public func fetch() -> Observable<[Plans]> {
        return Observable.just([])
    }
    
    
}

private extension FetchPlansUseCaseSpy {
    func filterPlansForSelectedDate(plansArray: [Plans], selectedDate: Date) -> [Plans] {
        // 달력에서 선택된 날짜와 Plans의 날짜가 같은 것만 필터링
        let filteredPlans = plansArray.filter { plan in
            print("plan::\(plan.date),,, selected::: \(selectedDate)")
            let calendar = Calendar.current
            return calendar.isDate(plan.date, inSameDayAs: selectedDate)
        }
        
        return filteredPlans
    }
    
    func createSampleDate() -> [Plans] {
        let smapleDate = Date()
        let calendar = Calendar.current
        guard let current = calendar.date(bySetting: .day, value: 1, of: smapleDate),
        let tomorrow = calendar.date(bySetting: .day, value: 2, of: smapleDate),
        let yester = calendar.date(bySetting: .day, value: 3, of: smapleDate)
        else { return [] }
        
        let plans1 = Plans.stub(title: "프로젝트1", date: current)
        let plans2 = Plans.stub(title: "프로젝트2", date: tomorrow)
        let plans3 = Plans.stub(title: "프로젝트3", date: yester)
        let plansArray = [plans1, plans2, plans3]
        
        return plansArray
    }
}

