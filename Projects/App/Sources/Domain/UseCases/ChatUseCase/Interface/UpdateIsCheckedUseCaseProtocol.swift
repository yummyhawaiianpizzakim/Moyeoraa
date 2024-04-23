//
//  UpdateIsCheckedUseCaseProtocol.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/31.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol UpdateIsCheckedUseCaseProtocol {
    func update(chatroomId: String, chatId: String) -> Observable<Void>
}


