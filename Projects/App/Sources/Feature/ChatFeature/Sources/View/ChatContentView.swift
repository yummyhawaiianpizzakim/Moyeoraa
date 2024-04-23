//
//  ChatContentView.swift
//  ChatFeature
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class ChatContentView: UIView {
    
    // MARK: - Properties
    var sender: Chat.SenderType = .mine {
        didSet { applySenderType() }
    }
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        
        self.applySenderType()
        self.clipsToBounds = true
        self.layer.cornerRadius = 8.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func applySenderType() {
        self.backgroundColor = self.sender.backgroundColor
    }
}

// MARK: - SenderType
private extension Chat.SenderType {
    
    var backgroundColor: UIColor {
        switch self {
        case .mine:
            return .moyeora(.primary(.primary2))
        case .other:
            return .moyeora(.neutral(.gray4))
        }
    }
}
