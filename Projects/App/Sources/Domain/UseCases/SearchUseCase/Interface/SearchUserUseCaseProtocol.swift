//
//  SearchUserUseCaseProtocol.swift
//  SearchUseCaseInterface
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public protocol SearchUserUseCaseProtocol: AnyObject {
    func search(text: String) -> Observable<[User]>
}
