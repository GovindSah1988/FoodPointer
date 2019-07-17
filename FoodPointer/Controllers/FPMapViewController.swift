//
//  FPMapViewController.swift
//  FoodPointer
//
//  Created by Govind Sah on 30/05/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit
import MapKit

enum SearchText: String, CaseIterable {
    case pizza = "Pizza"
    case coffee = "Coffee"
    case iceCream = "Ice Cream"
    case restaurant = "Restaurant"
    case bar = "Bar"
    case atm = "ATM"
    case petrolPump = "Petrol Pump"
}

class FPMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightALC: NSLayoutConstraint!
    
    fileprivate var location: CLLocation?
    private var selectedAnnotation: MKAnnotation?
    private var mapItems: [FPMapItem]?

    lazy var locationInteractor: FPLocationSearchInteractor! = {
       return FPLocationSearchInteractor(delegate: self, mapView: self.mapView)
    }()
    
    let allowedSearchList: [SearchText] = SearchText.allCases
    var actualSearchList = [SearchText]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // fetch Current Location
        fetchCurrentLocation()
    }
    
    fileprivate func fetchCurrentLocation() {
        
        FPLocationManager.shared.getLocation { (location, error) in
            if nil == error, let location = location {
                self.location = location
                
                // setup the current location on the map
                let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                
            } else {
                //TODO: handle error
                let alertController = UIAlertController(title: nil, message: FPConstants.FPLocalizedStringConstants.locationAccessError, preferredStyle: .alert)
                let okAction = UIAlertAction(title: FPConstants.FPLocalizedStringConstants.alertOk, style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension FPMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actualSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FPConstants.FPViewIdentifiers.searchTVC, for: indexPath)
        cell.textLabel?.text = actualSearchList[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get the text and use MapKit to search for those keywords
        locationInteractor.fetchMapItems(for: actualSearchList[indexPath.row].rawValue)
        
        tableView.isHidden = true
        tableViewHeightALC.constant = 0
        searchBar.endEditing(true)
    }
}

extension FPMapViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let locationAvailable = (nil != location)
        if false == locationAvailable {
            let alertController = UIAlertController(title: nil, message: FPConstants.FPLocalizedStringConstants.grantLocationPermission, preferredStyle: .alert)
            let okAction = UIAlertAction(title: FPConstants.FPLocalizedStringConstants.alertOk, style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.isHidden = !locationAvailable
        return locationAvailable
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0 {
            actualSearchList = allowedSearchList.filter {
                return $0.rawValue.range(of: searchText, options: String.CompareOptions.caseInsensitive) != nil
            }
        } else {
            actualSearchList.removeAll()
        }
        tableView.isHidden = false
        tableViewHeightALC.constant = CGFloat(40 * actualSearchList.count)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension FPMapViewController: FPLocationSearchInteractorOutput {
    func matchingMapItems(mapItems: [FPMapItem]?, error: FPError?) {
        self.mapItems = mapItems
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MKAnnotation]()
        if let mapItems = mapItems {
            for mapItem in mapItems {
                let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = CLLocationCoordinate2D(latitude: mapItem.latitude, longitude: mapItem.longitude)
                print(annotation.title!)
                annotations.append(annotation)
            }
        }
        mapView.addAnnotations(annotations)
    }
}

extension FPMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotation = view.annotation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: FPConstants.FPViewIdentifiers.mapReuseId)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            pinView = dequeuedView
        } else {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: FPConstants.FPViewIdentifiers.mapReuseId)
            pinView.pinTintColor = UIColor.orange
            pinView.canShowCallout = true
            let button = UIButton.init(type: UIButton.ButtonType.detailDisclosure)
            button.addTarget(self, action: #selector(getDetails), for: UIControl.Event.touchUpInside)
            pinView.rightCalloutAccessoryView = button
        }
        
        // for showing blue color to current location
        if annotation.coordinate == location?.coordinate {
            pinView.pinTintColor = .blue
        }
        return pinView
    }
    
    @objc private func getDetails() {
        if let selectedAnnotation = selectedAnnotation, let mapItem = mapItems?.filter ({ return $0.latitude == selectedAnnotation.coordinate.latitude && $0.longitude == selectedAnnotation.coordinate.longitude }).first {
            let annotationDetailPageVC = FPAnnotationDetailViewController.annotationDetailVC()
            annotationDetailPageVC.mapItem = mapItem
            self.present(annotationDetailPageVC.navigationController!, animated: true, completion: nil)
        } else if selectedAnnotation?.coordinate == location?.coordinate {
            let alertController = UIAlertController(title: nil, message: FPConstants.FPLocalizedStringConstants.title, preferredStyle: .alert)
            let okAction = UIAlertAction(title: FPConstants.FPLocalizedStringConstants.alertOk, style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
