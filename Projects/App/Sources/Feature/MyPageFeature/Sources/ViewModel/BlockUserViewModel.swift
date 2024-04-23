//
//  BlockUserViewModel.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift
import RxCocoa

public struct BlockUserViewModelActions { }

public final class BlockUserViewModel: BaseViewModel {
    public var disposeBag = DisposeBag()
    public typealias Action = BlockUserViewModelActions
    public var actions: Action?
    
    private let fetchBlockedUserUseCase: FetchBlockedUserUseCaseProtocol
    private let deleteBlockUseCase: DeleteBlockUseCaseProtocol
    private let createBlockUseCase: CreateBlockUseCaseProtocol
    
    public init(fetchBlockedUserUseCase: FetchBlockedUserUseCaseProtocol,
         deleteBlockUseCase: DeleteBlockUseCaseProtocol,
         createBlockUseCase: CreateBlockUseCaseProtocol) {
        self.fetchBlockedUserUseCase = fetchBlockedUserUseCase
        self.deleteBlockUseCase = deleteBlockUseCase
        self.createBlockUseCase = createBlockUseCase
    }
    
    public struct Input {
    }
    
    public struct Output {
        let dataSource: Driver<[Block.BlockedUser]>
    }
    
    public func trnasform(input: Input) -> Output {
        let blockedUsers = self.fetchBlockedUserUseCase.fetch()
            .share()
        
        return Output(dataSource: blockedUsers.asDriver(onErrorJustReturn: [])
        )
    }
    
    public func setAction(_ actions: BlockUserViewModelActions) {
        self.actions = actions
    }
}

public extension BlockUserViewModel {
    func modifyBlockUser(_ id: String, isSelected: Bool) {
        isSelected ?
        self.deleteBlockUser(id) :
        self.createBlockUser(id)
    }
    
    func createBlockUser(_ id: String) {
        self.createBlockUseCase.create(id)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    func deleteBlockUser(_ id: String) {
        self.deleteBlockUseCase.delete(id)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
