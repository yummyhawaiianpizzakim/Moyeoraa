//
//  ObserveLocationUseCaseProtocol.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/29.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol ObserveLocationUseCaseProtocol {
    func observe(chatroomID: String) -> Observable<[SharedLocation]>
    func removeObserve() -> Observable<Void>
}
