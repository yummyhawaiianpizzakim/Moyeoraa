//
//  MYRToastView.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/22.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit

public final class MYRToastView: UIView {
    public enum ToastType: String {
        case success = "Success"
        case failure = "Failure"
        
        var color: UIColor {
            switch self {
            case .success:
                return .moyeora(.system(.success))
            case .failure:
                return .moyeora(.system(.error))
            }
        }
    }
    
    private enum Metric {
        static let leadingMargin: CGFloat = MYRConstants.leadingOffset
        static let trailingMargin = -leadingMargin
        static let bottomMargin = -8
        static let toastHeight: CGFloat = 40.0
    }
    
    // MARK: - UI Components
    
    private lazy var contentLabel: MYRLabel = .init("", textColor: .neutral(.balck), font: .body2)
    
    // MARK: - properties
    
    private let toastType: ToastType
    private var message: String
    public var followsUndockedKeyboard: Bool
    
    // MARK: - initialize
    
    public init(type: ToastType = .success, message: String = "", followsUndockedKeyboard: Bool = false) {
        self.toastType = type
        self.message = message
        self.followsUndockedKeyboard = followsUndockedKeyboard
        super.init(frame: .zero)
        
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setup Functions

private extension MYRToastView {
    func configureAttributes() {
        self.contentLabel.setText(with: self.message)
        
        self.backgroundColor = self.toastType.color
        self.layer.cornerRadius = MYRConstants.cornerRadiusMedium
    }
    
    func configureUI() {
        self.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
// MARK: - Public Functions

public extension MYRToastView {
    func setMessage(_ message: String) {
        self.message = message
        self.contentLabel.setText(with: message)
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        self.alpha = 0.8
        self.snp.makeConstraints { make in
            make.bottom.equalTo(self.followsUndockedKeyboard ? view.keyboardLayoutGuide : view.safeAreaLayoutGuide).offset(Metric.bottomMargin)
            make.leading.equalTo(view.snp.leading).offset(Metric.leadingMargin)
            make.trailing.equalTo(view.snp.trailing).offset(Metric.trailingMargin)
            make.height.equalTo(Metric.toastHeight)
        }
        UIView.animate(
            withDuration: 1.0,
            delay: 1.5,
            animations: {
                self.alpha = 0.0
            },
            completion: { [weak self] _ in
                self?.removeFromSuperview()
            })
    }
}
