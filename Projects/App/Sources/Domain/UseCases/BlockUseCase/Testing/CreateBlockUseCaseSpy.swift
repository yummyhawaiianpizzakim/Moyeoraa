//
//  CreateBlockUseCaseSpy.swift
//  BlockUseCaseInterface
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class CreateBlockUseCaseSpy: CreateBlockUseCaseProtocol {
    public init() { }
    
    public func create(_ blockID: String) -> RxSwift.Observable<Void> {
        print("createBlock")
        return Observable.just(())
    }
    
    
}
