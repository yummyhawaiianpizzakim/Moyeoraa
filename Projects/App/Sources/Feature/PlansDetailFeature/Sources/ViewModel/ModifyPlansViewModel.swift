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
    public let titleText = BehaviorRelay<String>(value: "")
    public let selectedDate = BehaviorRelay<Date?>(value: nil)
    public let selectedLocation = BehaviorRelay<Address?>(value: nil)
    public let selectedMembers = BehaviorRelay<[User]>(value: [])
    
    private let updatePlansUseCase: UpdatePlansUseCaseProtocol
    private let fetchPlansUseCase: FetchPlansUseCaseProtocol
    private let fetchUserUseCase: FetchUserUseCaseProtocol
    
    public init(
        plansID: String,
        updatePlansUseCase: UpdatePlansUseCaseProtocol,
        fetchPlansUseCase: FetchPlansUseCaseProtocol,
        fetchUserUseCase: FetchUserUseCaseProtocol) {
        self.plansID = plansID
        self.updatePlansUseCase = updatePlansUseCase
        self.fetchPlansUseCase = fetchPlansUseCase
        self.fetchUserUseCase = fetchUserUseCase
    }
    
    public struct Input {
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
        let plans = self.fetchPlansUseCase.fetch(id: self.plansID)
            .do { [weak self] plans in
                self?.titleText.accept(plans.title)
                self?.selectedDate.accept(plans.date)
                let address = self?.makeAddress(plans: plans)
                self?.selectedLocation.accept(address)
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
                    .update(title: title,
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
        
        self.selectedMembers.accept(tagedUsersValue)
    }
}

private extension ModifyPlansViewModel {
    func getUsers() -> [User] {
        let user1 = User(id: "qwer", name: "qqqq", tagNumber: 1234, fcmToken: "", isNotification: false)
        
        let user2 = User(id: "asdf", name: "wwww", tagNumber: 5678, fcmToken: "", isNotification: false)
        
        let user3 = User(id: "zxcv", name: "eeee", tagNumber: 1357, fcmToken: "", isNotification: false)
        
        let user4 = User(id: "5687", name: "zmxncbv", tagNumber: 1876, fcmToken: "", isNotification: false)
        
        let user5 = User(id: "1237", name: "zzqpoweif", tagNumber: 1658, fcmToken: "", isNotification: false)
        
        let user6 = User(id: "1457", name: "eeee", tagNumber: 1346, fcmToken: "", isNotification: false)
        
        let user7 = User(id: "4839", name: "eeee", tagNumber: 0493, fcmToken: "", isNotification: false)
        
        let user8 = User(id: "1928", name: "eeee", tagNumber: 0135, fcmToken: "", isNotification: false)
        
        let user9 = User(id: "4532", name: "eeee", tagNumber: 7642, fcmToken: "", isNotification: false)
        
        return [user1, user2, user3, user4, user5, user6,
                user7, user8, user9
        ]
    }
    
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
