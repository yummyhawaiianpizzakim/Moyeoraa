//
//  UpdatePlansUseCaseProtocol.swift
//  PlansUseCaseInterface
//
//  Created by 김요한 on 2024/04/11.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol UpdatePlansUseCaseProtocol: AnyObject {
    func update(id: String, title: String, date: Date, location: Address, members: [User]) -> Observable<Void>
}
