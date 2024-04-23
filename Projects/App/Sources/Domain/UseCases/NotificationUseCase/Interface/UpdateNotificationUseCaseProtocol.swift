//
//  UpdateNotificationUseCaseProtocol.swift
//  NotificationUseCaseInterface
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol UpdateNotificationUseCaseProtocol: AnyObject {
    func update(isNotification: Bool) -> Observable<Void>
}
