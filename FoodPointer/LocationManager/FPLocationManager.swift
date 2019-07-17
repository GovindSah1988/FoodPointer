//
//  FPLocationManager.swift
//  FoodPointer
//
//  Created by Govind Sah on 30/05/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation
import CoreLocation

typealias FPLocationManagerResponse = (CLLocation?, FPLocationError?) -> Void

class FPLocationManager: NSObject {
    
    static let shared = FPLocationManager()
    
    lazy var coreLocationManager: CLLocationManager? = {
        var clManager = CLLocationManager()
        clManager.desiredAccuracy = kCLLocationAccuracyBest
        clManager.requestWhenInUseAuthorization()
        clManager.delegate = self
        return clManager
    }()
    
    var locationResponse: FPLocationManagerResponse?
    
    override init() {
        super.init()
    }
    
    /**
     Method to return the user's location
     
     This method asynchronously requests for location
     
     - parameter completionHandler: RSLocationManagerResponse
     */
    func getLocation(completionHandler: @escaping FPLocationManagerResponse) {
        locationResponse = completionHandler
        
        if canRequestLocation() {
            let authorizedStatus = CLLocationManager.authorizationStatus()
            if authorizedStatus == .notDetermined {
                coreLocationManager?.requestWhenInUseAuthorization()
            }
            coreLocationManager?.startUpdatingLocation()
        } else {
            locationResponse?(nil, FPLocationError.locationServiceUnavailable)
        }
    }
    
    func canRequestLocation() -> Bool {
        return isLocationServiceEnabled() && isLocationServiceAuthorized()
    }
    
    /**
     Returns true if location service is enabled; false otherwise
     
     - returns: Bool
     */
    func isLocationServiceEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    /**
     Returns true if app is authorized to use location service; false otherwise
     
     - returns: Bool
     */
    func isLocationServiceAuthorized() -> Bool {
        let authorizedStatus = CLLocationManager.authorizationStatus()
        return (authorizedStatus != .denied && authorizedStatus != .restricted)
    }    
}

extension FPLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coreLocationManager?.stopUpdatingLocation()
        locationResponse?(nil, .locationServiceUnavailable)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coreLocationManager?.stopUpdatingLocation()
        if let location = manager.location {
            locationResponse?(location, nil)
        } else {
            locationResponse?(nil, .locationMissing)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            coreLocationManager?.startUpdatingLocation()
        case .denied:
            coreLocationManager?.stopUpdatingLocation()
        case .notDetermined:
            coreLocationManager?.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
