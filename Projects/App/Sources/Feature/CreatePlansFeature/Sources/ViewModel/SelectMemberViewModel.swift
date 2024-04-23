//
//  SelectMemberViewModel.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift
import RxCocoa

public struct SelectMemberViewModelActions {
    var closeSelectMemberFeature: (_ members: [User]) -> Void
}

public final class SelectMemberViewModel: BaseViewModel {
    public var disposeBag = DisposeBag()
    
    public typealias Action = SelectMemberViewModelActions
    public var actions: Action?
    
    public let tagedUsers = BehaviorRelay<[User]>(value: [])
    
    public let fetchFriendsUseCase: FetchFriendsUseCaseProtocol
    public let searchUserUseCase: SearchUserUseCaseProtocol
    public let createFriendUseCase: CreateFriendUseCaseProtocol
    public let deleteFriendUseCase: DeleteFriendUseCaseProtocol
    
    public init(fetchFriendsUseCase: FetchFriendsUseCaseProtocol, searchUserUseCase: SearchUserUseCaseProtocol, createFriendUseCase: CreateFriendUseCaseProtocol, deleteFriendUseCase: DeleteFriendUseCaseProtocol) {
        self.fetchFriendsUseCase = fetchFriendsUseCase
        self.searchUserUseCase = searchUserUseCase
        self.createFriendUseCase = createFriendUseCase
        self.deleteFriendUseCase = deleteFriendUseCase
    }
    
    public struct Input {
        let searchUsers: Observable<String>
        let selectedUser: Observable<User>
        let selectedFriend: Observable<Friend>
        let doneButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let friends: Driver<[Friend]>
        let users: Driver<[User]>
        let tags: Driver<[User]>
        let doneButtonIsEnabled: Driver<Bool>
    }
    
    public func trnasform(input: Input) -> Output {
        let friends = self.fetchFriendsUseCase.fetch().share()
        let searchedUsers = input.searchUsers
            .withUnretained(self)
            .flatMap { owner, keyword in
                owner.searchUserUseCase.search(text: keyword)
            }
            .share()
        
        input.selectedUser
            .subscribe(with: self) {
                $0.appendTagedUser($1)
            }
            .disposed(by: self.disposeBag)
        
        input.selectedFriend
            .withUnretained(self)
            .map {
                $0.convertFriendToUser($1)
            }
            .subscribe(with: self) {
                $0.appendTagedUser($1)
            }
            .disposed(by: self.disposeBag)
        
        input.doneButtonDidTap
            .withLatestFrom(self.tagedUsers)
            .subscribe(with: self) { owner, users in
                owner.actions?.closeSelectMemberFeature(users)
            }
            .disposed(by: self.disposeBag)
        
        let isEnabled = self.tagedUsers.asObservable()
            .map { $0.count == 0 ? false : true }
        
        return Output(
            friends: friends.asDriver(onErrorJustReturn: []),
            users: searchedUsers.asDriver(onErrorJustReturn: []),
            tags: self.tagedUsers.asDriver(onErrorJustReturn: []),
            doneButtonIsEnabled: isEnabled.asDriver(onErrorJustReturn: false)
        )
    }
    
    public func setAction(_ actions: SelectMemberViewModelActions) {
        self.actions = actions
    }
}

public extension  SelectMemberViewModel {
    func modifyFriend(_ userID: String, isSelected: Bool) {
        isSelected ?
        self.createFriend(userID) :
        self.deleteFriend(userID)
    }
    
    func createFriend(_ userID: String ) {
        self.createFriendUseCase.create(userID)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    func deleteFriend(_ userID: String) {
        self.deleteFriendUseCase.delete(userID)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    func deleteTagedUser(_ user: User) {
        var tagedUsersValue = self.tagedUsers.value
            .filter { oldUser in
                oldUser.id != user.id
            }
        
        self.tagedUsers.accept(tagedUsersValue)
    }
}

private extension  SelectMemberViewModel {
    func convertFriendToUser(_ friend: Friend) -> User {
        let user = User(id: friend.userID, name: friend.name, tagNumber: friend.tagNumber, profileImage: friend.prfileImage, fcmToken: "", isNotification: false)
        return user
    }
    
    func appendTagedUser(_ user: User) {
        guard !self.tagedUsers.value.contains(where: { $0.id == user.id })
        else { return }
        var tagedUsersValue = self.tagedUsers.value
        tagedUsersValue.append(user)
        self.tagedUsers.accept(tagedUsersValue)
    }
    
}
