//
//  UpdateUserUseCaseProtocol.swift
//  UserUseCaseInterface
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public protocol UpdateUserUseCaseProtocol: AnyObject {
    func update(profileURL: String?, name: String) -> Observable<Void>
}
