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
            .share()
        
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
}

private extension FriendsViewModel {

}
