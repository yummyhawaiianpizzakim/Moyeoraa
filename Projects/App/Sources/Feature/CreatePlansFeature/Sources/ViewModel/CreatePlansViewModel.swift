//
//  CreatePlansViewModel.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

public struct CreatePlansViewModelActions {
    var showSelectDateFeature: (_ viewModel: CreatePlansViewModel) -> Void
    var showSelectLocationFeature: (_ viewModel: CreatePlansViewModel) -> Void
    var showSelectMemberFeature: (_ members: [User], _ viewModel: CreatePlansViewModel) -> Void
    var finishCreatePlansFeature: () -> Void
}

public final class CreatePlansViewModel: BaseViewModel {
    public var disposeBag = DisposeBag()
    public typealias Action = CreatePlansViewModelActions
    public var actions: Action?
    
    public let selectedDate = BehaviorRelay<Date?>(value: nil)
    public let selectedLocation = BehaviorRelay<Address?>(value: nil)
    public let selectedMembers = BehaviorRelay<[User]>(value: [])
    
    private let createPlansUseCase: CreatePlansUseCaseProtocol
    
    public init(createPlansUseCase: CreatePlansUseCaseProtocol) {
        self.createPlansUseCase = createPlansUseCase
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
        let isEnableDoneButton: Driver<Bool>
        let result: Observable<Void>
    }
    
    public func trnasform(input: Input) -> Output {
        let inputData = Observable.combineLatest(
            input.titleText,
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
                return owner.createPlansUseCase.create(
                    title: title,
                    date: date,
                    location: location,
                    members: members) }
        
        let isEnableDoneButton = inputData
            .withUnretained(self)
            .map { owner, val in
                let (title, date, location, _) = val
                return owner.isEnableDoneButton(title: title, date: date, location: location)
            }
        
        return Output(
            users: self.selectedMembers.asDriver(onErrorJustReturn: []),
            isEnableDoneButton: isEnableDoneButton.asDriver(onErrorJustReturn: false),
            result: result
        )
    }
    
    public func setAction(_ actions: CreatePlansViewModelActions) {
        self.actions = actions
    }
    
    public func deleteTagedUser(_ user: User) {
        var tagedUsersValue = self.selectedMembers.value
            .filter { oldUser in
                oldUser.id != user.id
            }
        
        self.selectedMembers.accept(tagedUsersValue)
    }
}

private extension CreatePlansViewModel {
    func isEnableDoneButton(title: String, date: Date?, location: Address?) -> Bool {
        guard (date != nil), (location != nil), !title.isEmpty
        else { return false }
        return true
    }
    
    private func getUsers() -> [User] {
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
}

extension CreatePlansViewModel: SelectDateCoordinatorDelegate, SelectLocationCoordinatorDelegate, SelectMemberCoordinatorDelegate {
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
