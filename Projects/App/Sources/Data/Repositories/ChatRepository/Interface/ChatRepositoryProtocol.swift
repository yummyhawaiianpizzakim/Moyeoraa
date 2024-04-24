//
//  ChatRepositoryProtocol.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol ChatRepositoryProtocol: AnyObject {
    func createChatRoom(plansID: String) -> Observable<String> 
}