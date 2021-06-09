//
//  LocationVM.swift
//  WeatherSearching
//
//  Created by Andres Chan on 8/6/2021.
//

import Foundation
import CoreLocation

final class LocationVM: NSObject, ObservableObject {
    
    static let shared = LocationVM()
    let locationManager = CLLocationManager()
    
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func requestPermission() {
        if self.locationManager.authorizationStatus == .authorizedWhenInUse || self.locationManager.authorizationStatus == .authorizedAlways {
            startUpdatingLocation()
        } else {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
}

extension LocationVM : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:      CLAuthorizationStatus) {
            switch status {
            case .notDetermined:
                print("notDetermined")
            case .authorizedWhenInUse, .authorizedAlways:
                self.startUpdatingLocation()
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            default:
                print("unknown")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        print(location)
    }
}
