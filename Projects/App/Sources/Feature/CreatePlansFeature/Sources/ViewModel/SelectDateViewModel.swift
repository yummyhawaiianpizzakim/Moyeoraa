//
//  SelectDateViewModel.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public struct SelectDateViewModelActions {
    var closeSelectDateFeature: (_ date: Date) -> Void
}

public final class SelectDateViewModel: BaseViewModel {
    public var disposeBag = DisposeBag()
    public typealias Action = SelectDateViewModelActions
    private var actions: Action?
    
    let selectedDate = BehaviorRelay<Date?>(value: nil)
    
    public init() {
        
    }
    
    public struct Input {
        let calendarDateDidTap: Observable<Date>
        let selectedDate: Observable<Date>
        let doneButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let times: Driver<[Date]>
        let isEnabledButton: Driver<Bool>
    }
    
    public func trnasform(input: Input) -> Output {
        let selectedDate = input.calendarDateDidTap.share()
        
        let times = selectedDate
            .withUnretained(self)
            .do(onNext: { owner, date in
                owner.selectedDate.accept(nil)
            })
            .map { owner, date in
                owner.createStartDate(date: date)
            }
        
        input.selectedDate
            .bind(to: self.selectedDate)
            .disposed(by: self.disposeBag)
        
        input.doneButtonDidTap
            .withLatestFrom(self.selectedDate)
//            .debug("doneButtonDidTap")
            .compactMap({ $0 })
            .subscribe(with: self) { owner, date in
                owner.actions?.closeSelectDateFeature(date)
            }
            .disposed(by: self.disposeBag)
        
        let isEnabledButton = self.selectedDate
            .map { date in
                date == nil ?
                false : true
            }
        
        return Output(
            times: times.asDriver(onErrorJustReturn: []),
            isEnabledButton: isEnabledButton.asDriver(onErrorJustReturn: false)
        )
    }
    
    public func setAction(_ actions: SelectDateViewModelActions) {
        self.actions = actions
    }
}

private extension SelectDateViewModel {
    func createStartDate(date: Date) -> [Date] {
        var calendar = Calendar.current
        
        var dateArray: [Date] = []
        let date = date
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let day = calendar.date(from: components) ?? Date()
        let newDate = calendar.date(byAdding: .day, value: +1, to: day) ?? Date()
        
        let hour = calendar.component(.hour, from: date) * 60
        let minute = calendar.component(.minute, from: date)
        let sum = hour + minute
        
        let count = (60 * 24 - sum) / 30
        for number in 0 ..< count {
            if let newDate = calendar.date(byAdding: .minute, value: -((number + 1) * 30), to: newDate) {
                dateArray.append(newDate)
            }
        }
        
        dateArray.reverse()
        return dateArray
    }
    
}
