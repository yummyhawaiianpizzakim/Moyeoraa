//
//  MainTabBarController.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/24/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import UIKit

public final class MainTabBarController: UITabBarController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

public extension MainTabBarController {
    func configureUI() {
        self.tabBar.tintColor = .moyeora(.primary(.primary2))
    }
}
