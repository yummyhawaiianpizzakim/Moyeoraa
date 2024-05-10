//
//  LocationShareViewModel.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/3/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public struct LocationShareViewModelActions {
}

public final class LocationShareViewModel: BaseViewModel {
    public typealias Action = LocationShareViewModelActions
    public let disposeBag = DisposeBag()
    public var actions: Action?
    private let chatRoomID: String
    public let members = BehaviorRelay<[User]>(value: [])
    
    private let fetchPlansUseCase: FetchPlansUseCaseProtocol
    private let fetchUserUseCase: FetchUserUseCaseProtocol
    private let updateLocationUseCase: UpdateLocationUseCaseProtocol
    private let observeLocationUseCase: ObserveLocationUseCaseProtocol
    private let endLocationShareUseCase: EndLocationShareUseCaseProtocol
    
    init(chatRoomID: String,
         fetchPlansUseCase: FetchPlansUseCaseProtocol,
         fetchUserUseCase: FetchUserUseCaseProtocol,
         updateLocationUseCase: UpdateLocationUseCaseProtocol,
         observeLocationUseCase: ObserveLocationUseCaseProtocol,
         endLocationShareUseCase: EndLocationShareUseCaseProtocol) {
        self.chatRoomID = chatRoomID
        self.fetchPlansUseCase = fetchPlansUseCase
        self.fetchUserUseCase = fetchUserUseCase
        self.updateLocationUseCase = updateLocationUseCase
        self.observeLocationUseCase = observeLocationUseCase
        self.endLocationShareUseCase = endLocationShareUseCase
    }
    
    public struct Input {
        let myCoordinate: Observable<Coordinate>
        let isArrived: Observable<Bool>
    }
    
    public struct Output {
        let title: Driver<String>
        let members: Driver<[User]>
        let mapCoordinate: Driver<Coordinate>
        let sharedLocations: Driver<[SharedLocation]>
        let userAnnotations: Driver<[String: UserAnnotationView]>
    }
    
    public func trnasform(input: Input) -> Output {
        let plans = self.fetchPlansUseCase
            .fetch(chatRoomID: self.chatRoomID)
            .share()
        
        let sharedLocations = observeLocationUseCase
            .observe(chatroomID: self.chatRoomID)
            .share()
        
        let title = plans.map { $0.title }
        
        plans.withUnretained(self)
            .flatMap { owner, plans in
                owner.fetchUserUseCase.fetch(userIDs: plans.usersID)
            }
            .bind(to: self.members)
            .disposed(by: self.disposeBag)
        
        let coordinate = plans.map { Coordinate(lat: $0.latitude, lng: $0.longitude) }
        
        let myCoordinate = Observable.combineLatest(input.myCoordinate, input.isArrived).share()
        
        self.updateMyCoordinate(myCoordinate.take(1))
        self.updateMyCoordinate(myCoordinate
            .buffer(timeSpan: .seconds(10), count: .max, scheduler: ConcurrentMainScheduler.instance)
            .compactMap({ $0.last }))
        
        let sharedLocationsCountChanged = sharedLocations
            .map { $0.count } // 세어로케이션스 배열의 갯수를 추출
            .distinctUntilChanged()
            .withLatestFrom(sharedLocations)
        
        let userAnnotations = Observable.combineLatest(sharedLocationsCountChanged, self.members.skip(1))
            .withUnretained(self)
//            .debug("userAnnotations")
            .map({ owner, val in
                let (sharedLocations, users) = val
                return owner.generateAnnotations(sharedLocations: sharedLocations, users: users)
            })
        
        return Output(
            title: title.asDriver(onErrorJustReturn: ""),
            members: self.members.asDriver(onErrorJustReturn: []),
            mapCoordinate: coordinate.asDriver(onErrorJustReturn: Coordinate(lat: 37.553836, lng: 126.969652)),
            sharedLocations: sharedLocations.asDriver(onErrorJustReturn: []),
            userAnnotations: userAnnotations.asDriver(onErrorJustReturn: [:])
        )
    }
    
    public func setAction(_ actions: LocationShareViewModelActions) {
        self.actions = actions
    }
}

public extension LocationShareViewModel {
    func endLocationShare() {
        self.observeLocationUseCase.removeObserve()
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.endLocationShareUseCase
                    .complete(chatRoomID: owner.chatRoomID)
            }
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}

private extension LocationShareViewModel {
    func updateMyCoordinate(_ input: Observable<(Coordinate, Bool)>) {
        input
            .withUnretained(self)
            .flatMap { owner, val in
                let (coordinate, isArrived) = val
                return owner.updateLocationUseCase.update(chatRoomID: owner.chatRoomID, coordinate: coordinate, isArrived: isArrived)
            }
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    func generateCoordinate(sharedLocations: [SharedLocation]) -> [Coordinate] {
        return sharedLocations.map { Coordinate(lat: $0.latitude, lng: $0.longitude) }
    }
    
    func generateAnnotations(sharedLocations: [SharedLocation], users: [User]) -> [String: UserAnnotationView] {
        var latestSharedLocations: [String: SharedLocation] = [:]
        var result: [String: UserAnnotationView] = [:]
        
        // 사용자별 최신 위치 정보 업데이트
        sharedLocations.forEach { sharedLocation in
            latestSharedLocations[sharedLocation.userID] = sharedLocation
        }
        
        // 최신 위치 정보를 바탕으로 어노테이션 생성
        users.forEach { user in
            if let sharedLocation = latestSharedLocations[user.id] {
                let userAnnotationView = self.createUserAnnotationView(sharedLocation: sharedLocation, user: user)
                result[user.id] = userAnnotationView
            }
        }
        
        return result
    }
    
    func createUserAnnotationView(sharedLocation: SharedLocation, user: User) -> UserAnnotationView {
        let userAnnotationView = UserAnnotationView()
        userAnnotationView.userImageURLString = user.profileImage
        userAnnotationView.coordinate = .init(latitude: sharedLocation.latitude, longitude: sharedLocation.longitude)
        userAnnotationView.setUserID(id: user.id)
        return userAnnotationView
    }
}
