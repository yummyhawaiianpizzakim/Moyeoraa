//
//  FriendsTVC.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/03.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class FriendsTVC: MYRSearchUserTVC {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.profileView.image = nil
        self.userNameLabel.setText(with: "")
        self.userTagLabel.setText(with: "")
    }
}
