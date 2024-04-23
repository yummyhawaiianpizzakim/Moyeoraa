//
//  DropOutUseCaseSpy.swift
//  AuthUseCaseInterface
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class DropOutUseCaseSpy: DropOutUseCaseProtocol {
    public init() { }
    
    public func dropOut() -> Observable<Void> {
        print("dropOut")
        return Observable.just(())
    }
}
