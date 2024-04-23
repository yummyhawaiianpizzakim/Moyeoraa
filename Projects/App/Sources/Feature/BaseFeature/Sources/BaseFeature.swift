//
//  BaseFeature.swift
//  BaseFeature
//
//  Created by 김요한 on 2024/03/27.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

open class BaseFeature: UIViewController {
    
    // MARK: - Properties
    public let disposeBag = DisposeBag()
    
    
    @available(*, unavailable)
    required public init(coder: NSCoder) {
        fatalError("init(coder:) is called.")
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Methods
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureAttributes()
        self.configureUI()
        self.bindViewModel()
    }
    
    open func configureAttributes() {}
    open func configureUI() {}
    open func bindViewModel() {}
}
