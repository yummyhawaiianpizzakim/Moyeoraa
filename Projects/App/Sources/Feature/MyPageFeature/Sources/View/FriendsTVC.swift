//
//  FriendsTVC.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

public final class FriendsTVC: MYRSearchUserTVC {
    public var disposeBag = DisposeBag()
    
    public var blockFriendTrigger = PublishRelay<Void>()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let interaction = UIContextMenuInteraction(delegate: self)
        self.contentView.addInteraction(interaction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.profileView.image = nil
        self.userNameLabel.setText(with: "")
        self.userTagLabel.setText(with: "")
        self.disposeBag = DisposeBag()
    }
}


extension FriendsTVC: UIContextMenuInteractionDelegate {
    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return .init(identifier: nil, previewProvider: nil) { [weak self] menus in
            guard let self else { return UIMenu() }
            return UIMenu(children: self.createMenuItems())
        }
    }
    
    func createMenuItems() -> [UIAction] {
        return [
            UIAction(
                title: "차단하기",
                handler: { [weak self] _ in
                    self?.blockFriendTrigger.accept(())
                }
            )
        ]
    }
}
