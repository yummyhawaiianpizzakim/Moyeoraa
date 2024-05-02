//
//  MoyeoraSearchView.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/20.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

public final class MYRSearchView: UIView {
    let disposeBag = DisposeBag()
    // MARK: UI
    
    public let iconTextField = MYRIconTextField(placeholder: "검색", icon: .Moyeora.search)
    
    // MARK: Properties
    public override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    // MARK: Initializers
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAttributes()
        self.configureUI()
    }
    
    public init() {
        super.init(frame: .zero)
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MYRSearchView {
    func configureUI() {
        [self.iconTextField].forEach {
            self.addSubview($0)
        }
        
        self.iconTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func configureAttributes() {
        self.backgroundColor = .white
    }
    
}

public extension MYRSearchView {
}
