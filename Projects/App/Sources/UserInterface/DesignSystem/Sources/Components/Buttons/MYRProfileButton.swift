//
//  MoyeoraProfileButton.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/20.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

public final class MYRProfileButton: UIButton {
    
    private var size: CGSize
    
    public var profileView = MYRIconView(size: .custom(.init(width: 96, height: 96)),image: .Moyeora.user, isCircle: true)
    
    private let editImage = MYRIconView(image: .Moyeora.edit, isCircle: true)
    
    public init(size: CGSize) {
        self.size = size
        super.init(frame: .zero)
        self.configureImage()
        self.configureAttributes()
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        self.configureAttributes()
    }
}

private extension MYRProfileButton {
    func configureAttributes() {
        self.profileView.layer.borderColor = UIColor.moyeora(.neutral(.balck)).cgColor
        self.profileView.layer.borderWidth = 1
        self.editImage.backgroundColor = .moyeora(.primary(.primary2))
    }
    
    func configureUI() {
        [self.profileView, self.editImage].forEach { view in
            self.addSubview(view)
        }
        
        self.profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.editImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureImage() {
        let profileView = MYRIconView(size: .custom(self.size),image: .Moyeora.user, isCircle: true)
        self.profileView = profileView
    }
}

public extension MYRProfileButton {
    func bindImage(urlString: String) {
        self.profileView.bindImage(urlString: urlString)
    }
    
    var profileButtonDidTap: Observable<Void> {
        self.rx.tap
            .asObservable()
    }
}
