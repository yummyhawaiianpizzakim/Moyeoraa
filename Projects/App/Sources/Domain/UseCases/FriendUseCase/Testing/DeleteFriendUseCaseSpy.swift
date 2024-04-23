//
//  DeleteFriendUseCaseSpy.swift
//  FriendUseCaseInterface
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class DeleteFriendUseCaseSpy: DeleteFriendUseCaseProtocol {
    public init() { }
    
    public func delete(_ id: String) -> Observable<Void> {
        print("deleteFrrr")
        return Observable.just(())
    }
    
    
}
