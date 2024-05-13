//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by 김요한 on 2024/03/27.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

public struct HomeViewModelActions {
    var showCreatePlansFeature: () -> Void
    var showPlansDetailFeature: (_ id: String) -> Void
}

public final class HomeViewModel: BaseViewModel {
    public typealias Action = HomeViewModelActions
    public var disposeBag = DisposeBag()
    public var actions: Action?
    public let fetchPlansUseCase: FetchPlansUseCaseProtocol
    
    public init(fetchPlansUseCase: FetchPlansUseCaseProtocol) {
        self.fetchPlansUseCase = fetchPlansUseCase
    }
    
    public struct Input {
        let viewDidAppear: Observable<Void>
        let calendarViewSelectedDate: Observable<Date>
        let plansDidSelect: Observable<Plans>
        let plusButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let plansArrInDate: Driver<[Plans]>
        let plansArrIHad: Driver<[Plans]>
    }
    
    public func trnasform(input: Input) -> Output {
        let selectedDate = input.calendarViewSelectedDate.share()
        
        let viewDidAppear = input.viewDidAppear.share()
        
        let plansArrIHad = viewDidAppear
            .debug("plansArrIHad")
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<[Plans]> in
                owner.fetchPlansUseCase.fetch()
            }
        
        let plansArrInDate = Observable.combineLatest(plansArrIHad, selectedDate)
            .debug("plansArrInDate")
            .withUnretained(self)
            .map { owner, val in
                let (plansArr, date) = val
                return owner.filterPlansArrInDate(plansArr: plansArr, selectedDate: date)
            }
        
        input.plansDidSelect
//            .debug("plansDidSelect")
            .subscribe(with: self) { owner, plans in
                owner.actions?.showPlansDetailFeature(plans.id)
            }
            .disposed(by: self.disposeBag)
        
        input.plusButtonDidTap
//            .debug("plusButtonDidTap")
            .subscribe(with: self) { owner, _ in
                owner.actions?.showCreatePlansFeature()
            }
            .disposed(by: self.disposeBag)
        
        
        return Output(plansArrInDate: plansArrInDate.asDriver(onErrorJustReturn: []), plansArrIHad: plansArrIHad.asDriver(onErrorJustReturn: []))
    }
    
    public func setAction(_ actions: HomeViewModelActions) {
        self.actions = actions
    }
    
}

private extension HomeViewModel {
    func filterPlansArrInDate(plansArr: [Plans], selectedDate: Date) -> [Plans] {
        return plansArr.filter { plans in
            let dateString = plans.date.toStringWithCustomFormat(.yearToDay)
            let selectedDateString = selectedDate.toStringWithCustomFormat(.yearToDay)
            
            return selectedDateString == dateString
        }
    }
}
