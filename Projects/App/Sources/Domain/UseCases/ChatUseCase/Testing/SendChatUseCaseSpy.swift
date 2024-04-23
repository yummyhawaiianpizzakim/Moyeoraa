//
//  SendChatUseCaseSpy.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/31.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public final class SendChatUseCaseSpy: SendChatUseCaseProtocol {
    public init() {
        
    }
    public func send(content: String, chatRoomID: String) -> Observable<Void> {
        return Observable.just(())
    }
}
