//
//  DeleteBlockUseCaseSpy.swift
//  BlockUseCaseInterface
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//
import RxSwift

public final class DeleteBlockUseCaseSpy: DeleteBlockUseCaseProtocol {
    public init() {
    }
    
    public func delete(_ id: String) -> Observable<Void> {
        print("tapDeleteButton")
        return Observable.just(())
    }
}
