//
//  DeleteBlockUseCaseProtocol.swift
//  BlockUseCaseInterface
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public protocol DeleteBlockUseCaseProtocol: AnyObject {
    func delete(_ id: String) -> Observable<Void>
}
