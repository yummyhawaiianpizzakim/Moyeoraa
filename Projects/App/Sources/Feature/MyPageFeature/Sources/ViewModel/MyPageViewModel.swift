//
//  MyPageViewModel.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

public struct MyPageViewModelActions {
    var showEditProfileFeature: (_ userID: String) -> Void
    var showFriendsFeature: (_ userID: String) -> Void
    var showBlockUserFeature: (_ userID: String) -> Void
    var finishMainTapFeature: () -> Void
}

public final class MyPageViewModel: BaseViewModel {
    public typealias Action = MyPageViewModelActions
    public var disposeBag = DisposeBag()
    private var actions: Action?
    private let alertTrigger = PublishRelay<MyPageCellType>()
    
    private let fetchUserUseCase: FetchUserUseCaseProtocol
    private let updateNotificationUseCase: UpdateNotificationUseCaseProtocol
    private let signOutUseCase: SignOutUseCaseProtocol
    private let dropOutUseCase: DropOutUseCaseProtocol
    
    public init(fetchUserUseCase: FetchUserUseCaseProtocol,
         updateNotificationUseCase: UpdateNotificationUseCaseProtocol,
         signOutUseCase: SignOutUseCaseProtocol,
         dropOutUseCase: DropOutUseCaseProtocol) {
        self.fetchUserUseCase = fetchUserUseCase
        self.updateNotificationUseCase = updateNotificationUseCase
        self.signOutUseCase = signOutUseCase
        self.dropOutUseCase = dropOutUseCase
    }
    
    public struct Input {
        let viewDidAppear: Observable<Void>
        let editButtonDidTap: Observable<Void>
        let cellDidSelect: Observable<MyPageCellType?>
    }
    
    public struct Output {
        let userAndDataSource: Driver<(User, MyPageDataSource)>
        let alertTrigger: Driver<MyPageCellType>
    }
    
    public func trnasform(input: Input) -> Output {
        let viewDidAppear = input.viewDidAppear.share()
        
        let userAndDataSorce = viewDidAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchUserAndDataSources()
            }
        
        input.editButtonDidTap
            .subscribe(with: self) { owner, _ in
                print("showEditProfileFeature")
                owner.actions?.showEditProfileFeature("asdasd")
            }
            .disposed(by: self.disposeBag)
        
        input.cellDidSelect
            .subscribe(with: self) { owner, cellType in
                switch cellType {
                case .friends:
                    print("showFriendsFeature")
                    owner.actions?.showFriendsFeature("asd")
                    return
                case .block:
                    print("showBlockFeature")
                    owner.actions?.showBlockUserFeature("asdasd")
                    return
                case .signOut:
                    owner.alertTrigger.accept(.signOut)
                    return
                case .dropout:
                    owner.alertTrigger.accept(.dropout)
                    return
                default:
                    return
                }
            }
            .disposed(by: self.disposeBag)
        
        return Output(
            userAndDataSource: userAndDataSorce.asDriver(
            onErrorDriveWith: Driver.empty()),
            alertTrigger: self.alertTrigger.asDriver(
                onErrorJustReturn: .version)
        )
    }
    
    public func setAction(_ actions: MyPageViewModelActions) {
        self.actions = actions
    }
}

public extension MyPageViewModel {
    func updateNotification(_ isNotofication: Bool) {
        self.updateNotificationUseCase.update(isNotification: isNotofication)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    func signOut() {
        self.signOutUseCase.signOut()
            .subscribe(with: self, onNext: { owner, _ in
                owner.actions?.finishMainTapFeature()
            })
            .disposed(by: self.disposeBag)
    }
    
    func dropOut() {
        self.dropOutUseCase.dropOut()
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}

private extension MyPageViewModel {
    func fetchUserAndDataSources() -> Observable<(User, MyPageDataSource)> {
        self.fetchUserUseCase.fetch()
            .withUnretained(self)
            .flatMap { owner, user in
                let dataSource = owner.generateDataSources(isOn: user.isNotification)
                return Observable.just((user, dataSource))
            }
    }
    
    func generateDataSources(isOn: Bool) -> MyPageDataSource {
        let setting: [MyPageCellType] = [
            .nofitication(isOn),
            .friends,
            .block,
            .signOut,
            .dropout
        ]
        
        let info: [MyPageCellType] = [ .version ]
        
        return [.setting: setting, .info: info]
    }
}
