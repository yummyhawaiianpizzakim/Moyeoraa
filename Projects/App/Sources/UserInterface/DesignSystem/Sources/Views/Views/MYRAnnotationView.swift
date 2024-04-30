//
//  MYRAnnotationView.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/30/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import MapKit

public final class MYRAnnotationView: MKAnnotationView, MKAnnotation {
    
    // MARK: - Properties
    dynamic public var coordinate = CLLocationCoordinate2D()
    public var isMine = true
    
    // MARK: - Initializers
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
}
