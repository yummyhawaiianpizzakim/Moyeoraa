//
//  FetchPlansUseCaseProtocol.swift
//  PlansUseCaseInterface
//
//  Created by 김요한 on 2024/03/28.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol FetchPlansUseCaseProtocol {
    func fetch(date: Observable<Date>) -> Observable<[Plans]>
    func fetch(id: String) -> Observable<Plans>
    func fetch(chatRoomID: String) -> Observable<Plans>
}
