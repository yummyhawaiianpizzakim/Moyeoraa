//
//  ModifyPlansViewModel.swift
//  PlansDetailFeature
//
//  Created by 김요한 on 2024/04/11.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

public struct ModifyPlansViewModelActions {
    var showSelectDateFeature: (_ viewModel: ModifyPlansViewModel) -> Void
    var showSelectLocationFeature: (_ viewModel: ModifyPlansViewModel) -> Void
    var showSelectMemberFeature: (_ members: [User], _ viewModel: ModifyPlansViewModel) -> Void
    var finishModifyPlansFeature: () -> Void
}

public final class ModifyPlansViewModel: BaseViewModel {
    public var disposeBag = DisposeBag()
    public typealias Action = ModifyPlansViewModelActions
    public var actions: Action?
    
    private let plansID: String
    private var makingUserID: String?
    public let titleText = BehaviorRelay<String>(value: "")
    public let selectedDate = BehaviorRelay<Date?>(value: nil)
    public let selectedLocation = BehaviorRelay<Address?>(value: nil)
    public let selectedMembers = BehaviorRelay<[User]>(value: [])
    
    private let updatePlansUseCase: UpdatePlansUseCaseProtocol
    private let fetchPlansUseCase: FetchPlansUseCaseProtocol
    private let fetchUserUseCase: FetchUserUseCaseProtocol
    private let kickOutUserUseCase: KickOutUserUseCaseProtocol
    
    public init(
        plansID: String,
        updatePlansUseCase: UpdatePlansUseCaseProtocol,
        fetchPlansUseCase: FetchPlansUseCaseProtocol,
        fetchUserUseCase: FetchUserUseCaseProtocol,
        kickOutUserUseCase: KickOutUserUseCaseProtocol
    ) {
        self.plansID = plansID
        self.updatePlansUseCase = updatePlansUseCase
        self.fetchPlansUseCase = fetchPlansUseCase
        self.fetchUserUseCase = fetchUserUseCase
        self.kickOutUserUseCase = kickOutUserUseCase
    }
    
    public struct Input {
        let viewDidAppear: Observable<Void>
        let titleText: Observable<String>
        let dateButtonDidTap: Observable<Void>
        let locationButtonDidTap: Observable<Void>
        let memberButtonDidTap: Observable<Void>
        let doneButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let users: Driver<[User]>
        let result: Observable<Void>
    }
    
    public func trnasform(input: Input) -> Output {
        let plans = self.fetchPlansUseCase
            .fetch(id: self.plansID)
            .do { [weak self] plans in
                self?.titleText.accept(plans.title)
                self?.selectedDate.accept(plans.date)
                let address = self?.makeAddress(plans: plans)
                self?.selectedLocation.accept(address)
                self?.makingUserID = plans.makingUserID
            }
            .share()
        
        plans.withUnretained(self)
            .flatMap { owner, plans in
                owner.fetchUserUseCase.fetch(userIDs: plans.usersID)
            }
            .bind(to: self.selectedMembers)
            .disposed(by: self.disposeBag)
        
        input.titleText
            .skip(1)
            .bind(to: self.titleText)
            .disposed(by: self.disposeBag)
        
        let inputData = Observable.combineLatest(
            self.titleText,
            self.selectedDate.startWith(nil),
            self.selectedLocation.startWith(nil),
            self.selectedMembers
        ).share()
        
        input.dateButtonDidTap
//            .debug("dateButtonDidTap")
            .subscribe(with: self) { owner, _ in
                owner.actions?.showSelectDateFeature(owner)
            }
            .disposed(by: self.disposeBag)

        input.locationButtonDidTap
//            .debug("locationButtonDidTap")
            .subscribe(with: self) { owner, _ in
                owner.actions?.showSelectLocationFeature(owner)
            }
            .disposed(by: self.disposeBag)

        input.memberButtonDidTap
//            .debug("memberButtonDidTap")
            .withLatestFrom(self.selectedMembers)
            .subscribe(with: self) { owner, members in
                owner.actions?.showSelectMemberFeature(members, owner)
            }
            .disposed(by: self.disposeBag)

        let result = input.doneButtonDidTap
            .withLatestFrom(inputData)
            .withUnretained(self)
            .flatMapFirst { owner, val -> Observable<Void> in
                let (title, date, location, members) = val
                guard let date, let location
                else { return Observable.just(()) }
                
                return owner.updatePlansUseCase
                    .update(id: owner.plansID,
                            title: title,
                            date: date,
                            location: location,
                            members: members)
            }
        
        return Output(
            users: self.selectedMembers.asDriver(onErrorJustReturn: []),
            result: result
        )
    }
    
    public func setAction(_ actions: ModifyPlansViewModelActions) {
        self.actions = actions
    }
    
    public func deleteTagedUser(_ user: User) {
        let tagedUsersValue = self.selectedMembers.value
            .filter { oldUser in
                oldUser.id != user.id
            }
        
        self.kickOutUserUseCase.kickOut(plansID: self.plansID, usersID: tagedUsersValue.map({ $0.id }))
            .subscribe(with: self) { owner, _ in
                owner.selectedMembers.accept(tagedUsersValue)
            }
            .disposed(by: self.disposeBag)
    }
    
    public func isMyself(id: String) -> Bool {
        self.makingUserID == id
    }
}

private extension ModifyPlansViewModel {
    func makeAddress(plans: Plans) -> Address {
        return Address(name: plans.location, address: plans.location, lat: plans.latitude, lng: plans.longitude)
    }
}

extension ModifyPlansViewModel: SelectDateCoordinatorDelegate, SelectLocationCoordinatorDelegate, SelectMemberCoordinatorDelegate {
    public func submitDate(_ date: Date) {
        self.selectedDate.accept(date)
    }
    
    public func submitLocation(_ location: Address) {
        self.selectedLocation.accept(location)
    }
    
    public func submitMembers(_ member: [User]) {
        self.selectedMembers.accept(member)
    }
    
}
