//
//  MoyeoraNavigationView.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/20.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

public final class MYRNavigationView: UIView {
    // MARK: Properties
    let disposeBag = DisposeBag()
    
    public override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    // MARK: UI
    private lazy var label = MYRLabel("", textColor: .neutral(.balck), font: .h2)
    
    // MARK: Initializers
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(title: String,
                textColor: UIColor.MYRColorSystem = .neutral(.balck),
                font: UIFont.MYRFontSystem = .h2
    ) {
        super.init(frame: .zero)
        self.configureAttributes(title: title, textColor: textColor, font: font)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MYRNavigationView {
    func configureAttributes(
        title: String,
        textColor: UIColor.MYRColorSystem,
        font: UIFont.MYRFontSystem
    ) {
        let label = MYRLabel(title, textColor: textColor, font: font)
        self.label = label
        self.label.textAlignment = .center
        self.backgroundColor = .white
    }
    
    func configureUI() {
        [self.label].forEach {
            self.addSubview($0)
        }
        
        self.label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}

public extension MYRNavigationView {
    func setText(_ text: String) {
        self.label.setText(with: text)
        self.label.textAlignment = .center
    }
}
