//
//  MYRMapView.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/30/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import MapKit
import SnapKit
import UIKit

public final class MYRMapView: MKMapView {
    public lazy var currentLocationButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: self)
        button.backgroundColor = .white
        button.tintColor = .lightGray
        button.layer.cornerRadius = 50.0 / 2
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.moyeora(.neutral(.balck)).cgColor
        button.mapView?.userTrackingMode = .none
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.configure()
        self.limitMapBoundary()
        self.addSubViews()
        self.makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        self.mapType = .standard
        self.showsUserLocation = false
        self.showsCompass = false
//        self.setUserTrackingMode(.follow, animated: true)
        self.userTrackingMode = .none
        self.isPitchEnabled = false
    }

    private func addSubViews() {
        addSubview(self.currentLocationButton)
    }

    private func makeConstraints() {
        self.currentLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20.0)
            $0.top.equalToSuperview().offset(70.0)
            $0.width.height.equalTo(50.0)
        }
    }

    private func limitMapBoundary() {
        // zoom out 제한
        cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 100,
            maxCenterCoordinateDistance: 1500000
        )

        // 이동 제한
        let topRight = CLLocationCoordinate2DMake(39.213099, 131.134438)
        let bottomLeft = CLLocationCoordinate2DMake(32.932619, 125.355630)

        let point1 = MKMapPoint(topRight)
        let point2 = MKMapPoint(bottomLeft)

        let mapRect = MKMapRect(
            x: fmin(point1.x, point2.x),
            y: fmin(point1.y, point2.y),
            width: fabs(point1.x - point2.x),
            height: fabs(point1.y - point2.y)
        )

        setCameraBoundary(CameraBoundary(mapRect: mapRect), animated: false)
    }
}
