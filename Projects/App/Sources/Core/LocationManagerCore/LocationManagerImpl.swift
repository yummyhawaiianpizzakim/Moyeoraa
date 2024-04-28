//
//  LocationManagerImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/28/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import MapKit
import RxSwift
import RxRelay

public final class LocationManagerImpl: NSObject, LocationManagerProtocol {

    // MARK: Properties
    private let disposeBag = DisposeBag()
    private var searchCompleter = MKLocalSearchCompleter()
    private let locationManager = CLLocationManager()
    
    private var results = BehaviorRelay<[Address]>(value: [])
    var curCoordinate = PublishRelay<Coordinate>()
    
    // MARK: Initializers
    public override init() {
        super.init()
        self.searchCompleter.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }

    // MARK: Methods
    public func setSearchText(with searchText: String) -> Observable<[Address]> {
        self.searchCompleter.queryFragment = searchText
        return self.results.asObservable()
    }
    
    public func fetchCurrentLocation() -> Result<Coordinate, Error> {
        guard let lat = locationManager.location?.coordinate.latitude,
            let lng = locationManager.location?.coordinate.longitude
        else { return  .failure(LocalError.locationAuthError) }
        
        return .success(Coordinate(lat: lat, lng: lng))
    }

    private func fetchSelectedLocationInfo(with selectedResult: MKLocalSearchCompletion) -> Single<Address?> {
        
        return Single.create { single in
            let searchRequest = MKLocalSearch.Request(completion: selectedResult)
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                guard error == nil else {
                    return single(.success(nil))
                }
                
                guard let placeMark = response?.mapItems[0].placemark else {
                    return single(.success(nil))
                }
                
                let coordinate = placeMark.coordinate
                return single(
                    .success(
                        Address(
                            name: selectedResult.title,
                            address: selectedResult.subtitle,
                            lat: coordinate.latitude,
                            lng: coordinate.longitude
                        )
                    )
                )
            }
            return Disposables.create()
        }
    }
}

extension LocationManagerImpl: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.curCoordinate.accept(Coordinate(lat: 0.0, lng: 0.0))
    }
}

extension LocationManagerImpl: MKLocalSearchCompleterDelegate {
    
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Observable.zip(completer.results.compactMap {
            self.fetchSelectedLocationInfo(with: $0).asObservable()
        })
        .map { locations -> [Address] in
            let filtered = locations.filter { $0 != nil }
            return filtered.compactMap { $0 }
        }
        .bind(to: self.results)
        .disposed(by: self.disposeBag)
    }
    
    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
