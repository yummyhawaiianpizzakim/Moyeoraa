//
//  FriendsViewModel.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift
import RxCocoa

public struct FriendsViewModelActions { }

public final class FriendsViewModel: BaseViewModel {
    public var disposeBag = DisposeBag()
    public typealias Action = FriendsViewModelActions
    public var actions: Action?
    
    public let blockedUsers = BehaviorRelay<[Block.BlockedUser]>(value: [])
    public let blockToastTrigger = PublishRelay<Void>()
    
    public let fetchFriendsUseCase: FetchFriendsUseCaseProtocol
    public let searchUserUseCase: SearchUserUseCaseProtocol
    public let createFriendUseCase: CreateFriendUseCaseProtocol
    public let deleteFriendUseCase: DeleteFriendUseCaseProtocol
    public let createBlockUseCase: CreateBlockUseCaseProtocol
    public let fetchBlockedUserUseCase: FetchBlockedUserUseCaseProtocol
    
    public init(fetchFriendsUseCase: FetchFriendsUseCaseProtocol, searchUserUseCase: SearchUserUseCaseProtocol, createFriendUseCase: CreateFriendUseCaseProtocol, deleteFriendUseCase: DeleteFriendUseCaseProtocol, createBlockUseCase: CreateBlockUseCaseProtocol,
                fetchBlockedUserUseCase: FetchBlockedUserUseCaseProtocol) {
        self.fetchFriendsUseCase = fetchFriendsUseCase
        self.searchUserUseCase = searchUserUseCase
        self.createFriendUseCase = createFriendUseCase
        self.deleteFriendUseCase = deleteFriendUseCase
        self.createBlockUseCase = createBlockUseCase
        self.fetchBlockedUserUseCase = fetchBlockedUserUseCase
    }
    
    public struct Input {
        let searchUsers: Observable<String>
    }
    
    public struct Output {
        let friends: Driver<[Friend]>
        let users: Driver<[User]>
    }
    
    public func trnasform(input: Input) -> Output {
        let friends = self.fetchFriendsUseCase.fetch().share()
        let searchedUsers = input.searchUsers
            .withUnretained(self)
            .flatMap { owner, keyword in
                owner.searchUserUseCase.search(text: keyword)
            }
            .withUnretained(self)
            .map { owner, users in
                owner.filterBlockedUser(searchedUsers: users, blockedUsers: owner.blockedUsers.value)
            }
            .share()
        
        self.fetchBlockedUserUseCase.fetch()
            .bind(to: self.blockedUsers)
            .disposed(by: self.disposeBag)
        
        return Output(
            friends: friends.asDriver(onErrorJustReturn: []),
            users: searchedUsers.asDriver(onErrorJustReturn: [])
        )
    }
    
    public func setAction(_ actions: FriendsViewModelActions) {
        self.actions = actions
    }
}

public extension  FriendsViewModel {
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
    
    func blockFriend(friendID: String, userID: String) {
        self.createBlockUseCase.create(friendID: friendID, userID: userID)
            .withUnretained(self)
            .flatMap({ owner, _ in
                owner.deleteFriendUseCase.delete(friendID: friendID)
            })
            .withUnretained(self)
            .flatMap({ owner, _ in
                owner.fetchBlockedUserUseCase.fetch()
            })
            .do(onNext: { [weak self] _ in
                self?.blockToastTrigger.accept(())
            })
            .bind(to: self.blockedUsers)
            .disposed(by: self.disposeBag)
    }
    
    func filterBlockedUser(searchedUsers: [User], blockedUsers: [Block.BlockedUser]) -> [User] {
        let blockedUserDict = Dictionary(uniqueKeysWithValues: blockedUsers.map({ ($0.blockedUser.id, $0) }))
        
        return searchedUsers.filter {
            $0.id == blockedUserDict[$0.id]?.blockedUser.id ?
            false : true
        }
    }
}

private extension FriendsViewModel {

}
