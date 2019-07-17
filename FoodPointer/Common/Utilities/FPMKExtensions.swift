//
//  FPMKExtensions.swift
//  FoodPointer
//
//  Created by Govind Sah on 31/05/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation
import MapKit

extension MKPlacemark {
    
    /// to get the address from MKPlacemark
    func address() -> String {
        var address = self.subThoroughfare ?? ""
        address = address.appendNextWord(self.thoroughfare)
        address = address.appendNextWord(self.subLocality)
        address = address.appendNextWord(self.locality)
        return address
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
}

extension MKMapItem {
    
    /// for converting MKMapItem -> FPMapItem
    func foodPointerMapItem() -> FPMapItem {
        let name = self.name
        let phoneNumber = self.phoneNumber
        let address = self.placemark.address()
        let coordinate = self.placemark.coordinate
        let fpMapItem = FPMapItem(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, phoneNumber: phoneNumber, address: address)
        return fpMapItem
    }
}
