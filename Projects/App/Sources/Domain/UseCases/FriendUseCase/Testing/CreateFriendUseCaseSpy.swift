//
//  CreateFriendUseCaseSpy.swift
//  FriendUseCaseInterface
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//
import RxSwift

public final class CreateFriendUseCaseSpy: CreateFriendUseCaseProtocol {
    public init() {
        
    }
    public func create(_ friendID: String) -> Observable<Void> {
        print("createFriend")
        return Observable.just(())
    }
    
}
