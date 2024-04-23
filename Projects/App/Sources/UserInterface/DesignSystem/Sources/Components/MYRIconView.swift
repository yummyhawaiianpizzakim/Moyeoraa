//
//  MoyeoraImageView.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/18.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import Kingfisher

public final class MYRIconView: UIImageView {
    public enum IconSize: Equatable {
        case big
        case small
        case custom(CGSize)
    }
    
    private var isCircle: Bool

    @Invalidating(.layout) public var size: IconSize = .big

    public init(size: IconSize = .big, image: UIImage? = nil, isCircle: Bool = false) {
        self.size = size
        self.isCircle = isCircle
        super.init(frame: .zero)
        self.image = image
        self.confiureAttributes()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.confiureAttributes()
    }
}

private extension MYRIconView {
    func confiureAttributes() {
        self.clipsToBounds = true
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        if isCircle {
            let radius = self.frame.height / 2
            self.layer.cornerRadius = radius
        }
    }
}

private extension MYRIconView.IconSize {
    var width: CGFloat {
        switch self {
        case .big: return 28
        case .small: return 24
        case let .custom(size): return size.width
        }
    }

    var height: CGFloat {
        switch self {
        case .big: return 28
        case .small: return 24
        case let .custom(size): return size.height
        }
    }
}

public extension MYRIconView {
    func bindImage(urlString: String) {
        let url = URL(string: urlString)
        self.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(_):
                return
            case .failure(_):
                self?.backgroundColor = .moyeora(.neutral(.gray5))
                self?.image = UIImage.Moyeora.user
                return
            }
        }
    }
}
