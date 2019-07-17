//
//  FPAnnotationDetailViewController.swift
//  FoodPointer
//
//  Created by Govind Sah on 31/05/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation
import UIKit

class FPAnnotationDetailViewController: UIViewController {
    
    var mapItem: FPMapItem!
    
    @IBOutlet weak var phoneNumberLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    
    class func annotationDetailVC() -> FPAnnotationDetailViewController {
        let storyboard = UIStoryboard.mainStoryboard()
        let navCon = storyboard.instantiateViewController(withIdentifier: FPConstants.FPViewIdentifiers.detailNavCon) as! UINavigationController
        return navCon.viewControllers[0] as! FPAnnotationDetailViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setUpDetails()
    }
    
    private func initialSetup() {
        setUpNavigationBar()
        
        // adding tap gesture to phone number so that when user taps on the phone number
        // the app opens the phone dial
        phoneNumberLB.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneNumberTapped))
        phoneNumberLB.addGestureRecognizer(tapGesture)
    }
    
    @objc private func phoneNumberTapped() {
        if let number = phoneNumberLB.text, let url = URL(string: "tel://\(number.removeSpaceAndSpecialCharacter())") {
            UIApplication.shared.open(url)
        }
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.title = mapItem.name
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancel))
    }
    
    private func setUpDetails() {
        phoneNumberLB.text = mapItem.phoneNumber
        addressLB.text = mapItem.address
    }

    @objc private func cancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
