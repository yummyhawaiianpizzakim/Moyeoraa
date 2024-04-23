//
//  UIViewController+.swift
//  FoundationUtilities
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public extension UIViewController {
    func setNavigationBar(isBackButton: Bool = false,
                          titleView: UIView?,
                          rightButtonItem: UIBarButtonItem?) {
        if isBackButton {
            let backButtonImage = UIImage(systemName: "chevron.left")?
                .withTintColor(.black, renderingMode: .alwaysOriginal)
            self.navigationController?.navigationBar.backIndicatorImage = backButtonImage
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
            self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        }
        
        if let titleView {
            self.navigationItem.titleView = titleView
        }

        if let rightButtonItem {
            self.navigationItem.rightBarButtonItem = rightButtonItem
            self.navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }
}
