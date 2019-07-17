//
//  FPConstants.swift
//  FoodPointer
//
//  Created by Govind Sah on 30/05/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct FPConstants {
    
    /// add all the localized constant here
    struct FPLocalizedStringConstants {
        static let title = "This is your current Location"
        static let grantLocationPermission = "Please grant permission to access your current location."
        static let locationAccessError = "Unable to access your current location."
        static let alertOk = "OK"
    }
    
    /// add all the view identifiers here
    struct FPViewIdentifiers {
        static let searchTVC = "FPSearchTableViewCell"
        static let mapReuseId = "FPMapAnnotationView"
        static let detailNavCon = "AnnotationDetailNavCon"
    }
    
    /// add all the storyboard name here
    struct FPStoryboardConstants {
        static let main = "Main"
    }
}

enum FPLocationError: Error {
    case locationServiceUnavailable
    case locationMissing
}

enum FPError {
    case noMapItems
}
