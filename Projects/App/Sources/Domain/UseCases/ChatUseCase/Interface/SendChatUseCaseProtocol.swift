//
//  SendChatUseCaseProtocol.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol SendChatUseCaseProtocol: AnyObject {
    func send(content: String, chatRoomID: String) -> Observable<Void>
}
