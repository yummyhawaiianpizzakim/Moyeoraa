//
//  PlansRepositoryProtocol.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol PlansRepositoryProtocol: AnyObject {
    func createPlans(plansID: String, makingUser: User, title: String, date: Date, location: Address, membersID: [String], chatRoomID: String) -> Observable<Void> 
}