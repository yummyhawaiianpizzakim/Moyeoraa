//
//  UpdateIsCheckedUseCaseImpl.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/31.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class UpdateIsCheckedUseCaseImpl: UpdateIsCheckedUseCaseProtocol {
    public init() {
        
    }
    
    public func update(chatroomId: String, chatId: String) -> Observable<Void> {
        
        return Observable.just(())
    }
    
}
