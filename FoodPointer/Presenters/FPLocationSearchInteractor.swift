//
//  FPLocationSearchInteractor.swift
//  FoodPointer
//
//  Created by Govind Sah on 30/05/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation
import MapKit

protocol FPLocationSearchInteractorOutput: class {
    func matchingMapItems(mapItems: [FPMapItem]?, error: FPError?)
}

/**
 Protocol that defines the Interactor's use case.
 */
protocol FPLocationSearchInteractorInput: class {
    func fetchMapItems(for text: String)
}

class FPLocationSearchInteractor: NSObject {
    
    // weak can never be let as the ARC can set nil to this variable whenever it needs to
    weak private var output: FPLocationSearchInteractorOutput?
    
    let mapView: MKMapView
    
    private var mapItems: [MKMapItem]?

    init(delegate: FPLocationSearchInteractorOutput, mapView: MKMapView) {
        output = delegate
        self.mapView = mapView
    }

}

extension FPLocationSearchInteractor: FPLocationSearchInteractorInput {
    func fetchMapItems(for text: String) {
        let request = MKLocalSearch.Request.init()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, _) in
            guard let response = response else {
                self?.output?.matchingMapItems(mapItems: nil, error: FPError.noMapItems)
                return
            }
            
            var mapItems = [FPMapItem]()
            for mapItem in response.mapItems {
                mapItems.append(mapItem.foodPointerMapItem())
            }
            self?.output?.matchingMapItems(mapItems: mapItems, error: nil)
        }
    }
}
