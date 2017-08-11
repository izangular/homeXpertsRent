//
//  LocationService.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 07/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import CoreLocation

open class LocationService {

    class func isLocationServiceEnabled() -> Bool {
        
        if CLLocationManager.locationServicesEnabled(){
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            print("Location service - Serice is not enabled")
            return false
        }
    }
}
