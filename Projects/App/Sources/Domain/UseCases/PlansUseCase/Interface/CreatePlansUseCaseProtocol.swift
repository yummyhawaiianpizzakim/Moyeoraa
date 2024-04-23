//
//  CreatePlansUseCaseProtocol.swift
//  PlansUseCaseInterface
//
//  Created by 김요한 on 2024/04/10.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol CreatePlansUseCaseProtocol: AnyObject {
    func create(title: String, date: Date, location: Address, members: [User]) -> Observable<Void>
}
