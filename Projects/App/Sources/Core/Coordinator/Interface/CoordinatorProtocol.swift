//
//  CoordinatorProtocol.swift
//  CoordinatorInterface
//
//  Created by 김요한 on 2024/03/29.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

public enum CoordinatorType {
    case app
    case tab
    case home, chat, myPage
    case createPlans, plansDetail, chatDetail
    case modifyPlans, selectDate, selectLocation, selectMember, searchUser, shareLocation
    case editProfile, blockUser, friends
    case signIn, signUp
}

public protocol CoordinatorProtocol: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var childCoordinators: [CoordinatorProtocol] { get set }
    var type: CoordinatorType { get }
    
    func start()
    func finish()
}


public extension CoordinatorProtocol {
    func finish() {
        self.childCoordinators.removeAll()
        self.finishDelegate?.coordinatorDidFinished(childCoordinator: self)
    }
}

public protocol CoordinatorFinishDelegate:AnyObject {
    func coordinatorDidFinished(childCoordinator: CoordinatorProtocol)
}
