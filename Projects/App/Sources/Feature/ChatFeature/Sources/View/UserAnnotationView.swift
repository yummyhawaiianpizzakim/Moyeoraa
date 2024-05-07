//
//  UserAnnotationView.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/4/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import SnapKit

public final class UserAnnotationView: MKAnnotationView, MKAnnotation {
    @objc dynamic public var coordinate = CLLocationCoordinate2D()
    
    public var userID: String?
    public var userImageURLString: String?
    
    private lazy var imageView = MYRIconView(size: .custom(.init(width: 50, height: 50)), isCircle: true)

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.configureAttributes()
        self.configureUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureAttributes() {
        self.clipsToBounds = true
        self.bounds.size = .init(width: 50, height: 50)
        self.layer.cornerRadius = 1
        self.layer.borderColor = UIColor.moyeora(.neutral(.white)).cgColor
    }
    
    private func configureUI() {
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setImage(imageURLString: String) {
        self.imageView.bindImage(urlString: imageURLString)
    }
    
    public func setUserID(id: String) {
        self.userID = id
    }
}
