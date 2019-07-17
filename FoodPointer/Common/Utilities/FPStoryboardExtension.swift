//
//  FPStoryboardExtension.swift
//  FoodPointer
//
//  Created by Govind Sah on 31/05/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

extension UIStoryboard {
    /// returns main story board
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: FPConstants.FPStoryboardConstants.main, bundle: nil)
    }
}
