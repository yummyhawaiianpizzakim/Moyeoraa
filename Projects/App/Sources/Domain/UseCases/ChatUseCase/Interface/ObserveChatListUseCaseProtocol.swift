//
//  FetchChatUseCaseProtocol.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/29.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol ObserveChatListUseCaseProtocol {
    func observe() -> Observable<([ChatRoom], [Plans])>
}
