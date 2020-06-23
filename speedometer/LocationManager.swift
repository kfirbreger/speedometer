//
//  LocationManager.swift
//  speedometer
//
//  Created by Kfir Breger on 19/06/2020.
//  Copyright © 2020 Conopa. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var currentLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var currentSpeed: CLLocationSpeed? {
        willSet {
            objectWillChange.send()
        }
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    var speedString: String {
        guard let speed = currentSpeed else {
            return "0"
        }
        return String(format:"%.2f", speed * 3.6)
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // If location accuracy is < 0 the speed is invalid: https://developer.apple.com/documentation/corelocation/cllocation/3524340-speedaccuracy
        if location.speedAccuracy < 0 {
            return
        }
        self.currentLocation = location
        self.currentSpeed = location.speed
        // For debugging
        print(#function, location)
    }

}
