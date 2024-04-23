//
//  MoyeoraTagButton.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/19.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class MYRTagView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    public var userLabel = MYRLabel()
    
    public var xButton = MYRIconButton(image: .Moyeora.x)
    
    public init(name: String) {
        super.init(frame: .zero)
        self.configureAttributes(name: name)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

public extension MYRTagView {
    var xButtonDidTap: Observable<Void> {
        self.xButton.rx.tap
            .asObservable()
    }
}

private extension MYRTagView {
    func configureAttributes(name: String) {
        self.layer.cornerRadius = MYRConstants.cornerRadiusMedium
        self.backgroundColor = .moyeora(.primary(.primary2))
        self.userLabel = MYRLabel(name, textColor: .neutral(.balck), font: .body3)
    }
    
    func configureUI() {
        self.addSubview(self.stackView)
        [self.userLabel, self.xButton].forEach { view in
            self.stackView.addArrangedSubview(view)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(36).priority(999)
        }
        
        self.userLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        self.xButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(28).priority(999)
        }
    }
}
