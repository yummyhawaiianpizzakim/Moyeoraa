//
//  TimeCVC.swift
//  CreatePlansFeature
//
//  Created by 김요한 on 2024/04/07.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public final class TimeCVC: UICollectionViewCell {
    public override var isSelected: Bool {
        didSet {
            self.updateSelectionAttributes(isSelected)
        }
    }
    
    private lazy var timeLabel = MYRLabel("00:00", textColor: .neutral(.balck), font: .body3)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAttributes() {
        self.contentView.backgroundColor = .moyeora(.neutral(.gray5))
        self.contentView.layer.cornerRadius = 8
        self.timeLabel.textAlignment = .center
    }
    
    private func configureUI() {
        self.contentView.addSubview(timeLabel)
        
        self.timeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func bindCell(with date: Date) {
        self.timeLabel.text = date.toStringWithCustomFormat("HH:mm")
    }
    
    private func updateSelectionAttributes(_ isSelected: Bool) {
        if isSelected {
            self.contentView.backgroundColor = .moyeora(.primary(.primary2))
            self.timeLabel.textColor = .moyeora(.neutral(.white))
            self.timeLabel.font = .moyeora(.body2)
        } else {
            self.contentView.backgroundColor = .moyeora(.neutral(.gray5))
            self.timeLabel.textColor = .moyeora(.neutral(.balck))
            self.timeLabel.font = .moyeora(.body3)
        }
    }
}
