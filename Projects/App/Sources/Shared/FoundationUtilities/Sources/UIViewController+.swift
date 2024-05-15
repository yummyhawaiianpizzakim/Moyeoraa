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
                          rightButtonItem: UIBarButtonItem?,
                          isSetTitleViewOnCenter: Bool = false) {
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
        
        if isSetTitleViewOnCenter && rightButtonItem == nil {
            let invisibleButton = UIBarButtonItem(image: .Moyeora.pin, style: .plain, target: nil, action: nil)
            invisibleButton.tintColor = .clear // 버튼을 투명하게 만들어 시각적으로 보이지 않게 함
            invisibleButton.isEnabled = false // 버튼이 눌러지지 않도록 비활성화
            self.navigationItem.rightBarButtonItem = invisibleButton
        }

        if let rightButtonItem {
            self.navigationItem.rightBarButtonItem = rightButtonItem
            self.navigationItem.rightBarButtonItem?.tintColor = .black
        }
        
    }
}
