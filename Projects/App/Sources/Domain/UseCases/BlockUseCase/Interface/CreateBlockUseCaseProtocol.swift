//
//  CreateBlockUseCaseProtocol.swift
//  BlockUseCaseInterface
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public protocol CreateBlockUseCaseProtocol: AnyObject {
    func create(_ userID: String) -> Observable<Void>
}
