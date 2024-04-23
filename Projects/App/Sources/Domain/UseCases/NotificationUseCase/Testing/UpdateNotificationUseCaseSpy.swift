//
//  UpdateNotificationUseCaseSpy.swift
//  NotificationUseCaseInterface
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class UpdateNotificationUseCaseSpy: UpdateNotificationUseCaseProtocol {
    public init() { }
    
    public func update(isNotification: Bool) -> Observable<Void> {
        print("update(isNotification")
        return Observable.just(())
    }
}
