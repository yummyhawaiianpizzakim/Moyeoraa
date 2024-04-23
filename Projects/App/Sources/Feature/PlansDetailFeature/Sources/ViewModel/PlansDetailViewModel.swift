//
//  PlansDetailViewModel.swift
//  PlansDetailFeatureInterface
//
//  Created by 김요한 on 2024/04/11.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public struct PlansDetailViewModelActions {
    var showChatRoomFeature: (_ id: String, _ title: String) -> Void
    var showModifyPlansFeature: (_ id: String) -> Void
    var finishPlansDetailFeature: () -> Void
}

public final class PlansDetailViewModel: BaseViewModel {
    public typealias Action = PlansDetailViewModelActions
    public let disposeBag = DisposeBag()
    public var actions: Action?
    
    private let plansID: String
    private let fetchPlansUseCase: FetchPlansUseCaseProtocol
    private let fetchUserUseCase: FetchUserUseCaseProtocol
    private let deletePlansUseCase: DeletePlansUseCaseProtocol
    
    
    public init(plansID: String,
                fetchPlansUseCase: FetchPlansUseCaseProtocol,
                fetchUserUseCase: FetchUserUseCaseProtocol,
                deletePlansUseCase: DeletePlansUseCaseProtocol) {
        self.plansID = plansID
        self.fetchPlansUseCase = fetchPlansUseCase
        self.fetchUserUseCase = fetchUserUseCase
        self.deletePlansUseCase = deletePlansUseCase
    }
    
    public struct Input {
        let enterChatButton: Observable<Void>
        let deleteTrigger: Observable<Void>
    }
    
    public struct Output {
        let title: Driver<String>
        let address: Driver<String>
        let date: Driver<Date>
        let memberCount: Driver<Int>
        let dataSource: Driver<[User]>
        let result: Observable<Void>
    }
    
    public func trnasform(input: Input) -> Output {
        let plans = self.fetchPlansUseCase.fetch(id: self.plansID).share()
        
        let title = plans.map({ $0.title }).asDriver(onErrorJustReturn: "")
        
        let address = plans.map({ $0.location }).asDriver(onErrorJustReturn: "")
        
        let date = plans.map({ $0.date }).asDriver(onErrorJustReturn: Date())
        
        let memberCount = plans.map({ $0.usersID.count }).asDriver(onErrorJustReturn: 0)
        
        input.enterChatButton
            .withLatestFrom(plans)
            .subscribe(with: self) { owner, plans in
                owner.actions?.showChatRoomFeature(plans.id, plans.title)
            }
            .disposed(by: self.disposeBag)
        
        let result = input.deleteTrigger
            .withLatestFrom(plans)
            .withUnretained(self)
            .flatMap { owner, plans in
                owner.deletePlansUseCase.delete(plansID: plans.id, chatRoomID: plans.chatRoomID)
            }
        
        let dataSource = plans
            .withUnretained(self)
            .flatMap { owner, plans -> Observable<[User]> in
                owner.fetchUserUseCase.fetch(userIDs: plans.usersID)
        }
        
        return Output(
            title: title,
            address: address,
            date: date,
            memberCount: memberCount,
            dataSource: dataSource.asDriver(onErrorJustReturn: []),
            result: result
        )
    }
    
    public func setAction(_ actions: PlansDetailViewModelActions) {
        self.actions = actions
    }
    
}

public extension PlansDetailViewModel {
    func showModifyPlansFeature() {
        self.actions?.showModifyPlansFeature(self.plansID)
    }
    
}

