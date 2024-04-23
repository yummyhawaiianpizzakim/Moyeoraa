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
        let Plans: Driver<[Plans]>
    }
    
    public func trnasform(input: Input) -> Output {
        let selectedDate = input.calendarViewSelectedDate.share()
        
        let plans = input.viewDidAppear
//            .debug("viewDidAppear")
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<[Plans]> in
                owner.fetchPlansUseCase.fetch(date: selectedDate)
            }
            .asDriver(onErrorJustReturn: [])
        
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
        
        
        return Output(Plans: plans)
    }
    
    public func setAction(_ actions: HomeViewModelActions) {
        self.actions = actions
    }
    
}
