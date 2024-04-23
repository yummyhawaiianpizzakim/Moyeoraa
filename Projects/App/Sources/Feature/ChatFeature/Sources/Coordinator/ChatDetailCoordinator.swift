//
//  ChatDetailCoordinator.swift
//  ChatFeature
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class ChatDetailCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .chatDetail
    
    public let navigation: UINavigationController
    
    private let chatRoomID: String
    private let chatRoomTitle: String
    
    public init(navigation: UINavigationController,
         chatRoomID: String,
         chatRoomTitle: String) {
        self.navigation = navigation
        self.chatRoomID = chatRoomID
        self.chatRoomTitle = chatRoomTitle
    }
    
    public func start() {
        self.showChatDetailFeature()
    }
    
    private func showChatDetailFeature() {
        let uc = ObserveChatUseCaseSpy()
        let uc1 = SendChatUseCaseSpy()
        let uc2 = UpdateIsCheckedUseCaseSpy()
        let vm = ChatDetailViewModel(
            chatRoomID: self.chatRoomID,
            chatRoomTitle: self.chatRoomTitle,
            observeChatUseCase: uc,
            sendChatUseCase: uc1,
            updateIsCheckedUseCase: uc2
        )
        let vc = ChatDetailFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
}
