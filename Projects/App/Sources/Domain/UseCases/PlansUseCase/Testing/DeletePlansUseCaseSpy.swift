//
//  DeletePlansUseCaseSpy.swift
//  PlansUseCaseInterface
//
//  Created by 김요한 on 2024/04/12.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class DeletePlansUseCaseSpy: DeletePlansUseCaseProtocol {
    public init() {
        
    }
    
    public func delete(plansID: String, chatRoomID: String) -> Observable<Void> {
        
//        return Observable.just(())
        return Observable.error(RxError.unknown)
    }
    
    
}
