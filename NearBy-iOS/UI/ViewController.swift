//
//  ViewController.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate {
    // Outlets
    @IBOutlet weak var errorView: UIStackView!
    
    @IBOutlet weak var errorImage: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var venuesTableView: UITableView!
    
    @IBOutlet weak var retryBUtton: UIButton!
    
    @IBOutlet weak var barItemButton: UIBarButtonItem!
    
    // Helper classes
    let networkReachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    let locationManager = CLLocationManager()
    let userDefaults = UserDefaults.standard
    var apiClient = ApiClient()
    
    // Properties
    var errorCode: AppError?
    var appMode: AppMode = .Realtime
    var lastLocationSentToServer: CLLocation?
    var venuesToShow = [Venue]()
    
    // Constants
    let ThresholdDistance = 500.0
    let AppModeKey = "AppMode"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegates
        venuesTableView.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = ThresholdDistance

        // Check internet
        networkReachabilityManager?.listener = { status in
            switch status {
            case .reachable(.ethernetOrWiFi):
                self.showProgress()
                self.locationManager.requestWhenInUseAuthorization()
            case .unknown: self.showProgress()
            default:
                // No internet
                let error = ErrorObject(messageBody: "No internet Available", imageName: "cloud", errorCode: .InternetNotAvailable)
                self.show(error)
            }
        }
        // Listen to network changes
        networkReachabilityManager?.startListening()
    }
    
    // TableView Implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venuesToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as? VenueTableViewCell
        if let venueCell = cell {
            let venue = venuesToShow[indexPath.row]
            venueCell.bindViews(with: venue)
            return venueCell
        }
        return UITableViewCell()
    }
    
    // Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            // Get the app mode
            appMode = AppMode(rawValue: userDefaults.integer(forKey: AppModeKey)) ?? .Realtime
            setBarButton()
            // TODO: Get the location
            if CLLocationManager.locationServicesEnabled() {
                switch(appMode) {
                case .Realtime:
                    locationManager.startUpdatingLocation()
                case .SingleUpdate:
                    locationManager.requestLocation()
                }
            } else {
                let error = ErrorObject(messageBody: "Please enable Location services to access your location", imageName: "location", errorCode: .LocationNotFound)
                show(error)
            }
            break
        case .denied, .restricted:
            let error = ErrorObject(messageBody: "Please grant the accees to location for the app to work properly", imageName: "location", errorCode: .LocationAcceessDenied)
            show(error)
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let currentLocation = location {
            guard let lastLocationRecorded = lastLocationSentToServer else {
                // No location recorded yet
                self.lastLocationSentToServer = currentLocation
                // TODO: Send a request with these coordintes
                self.sendRequest()
                return
            }
            
            let distance = currentLocation.distance(from: lastLocationRecorded)
            if distance > ThresholdDistance {
                // TODO: Send a request with these coordintes
                self.sendRequest()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let error = ErrorObject(messageBody: error.localizedDescription, imageName: "location", errorCode: .LocationNotFound)
        show(error)
    }
    
    // API functions
    
    func sendRequest() {
        if let currenLocation = lastLocationSentToServer {
            apiClient.getVenues(of: currenLocation) { [weak self] (venues, error) in
                guard let venues = venues else {
                    // Venues are nil
                    if let error = error {
                        // Error is not nil
                        self?.show(error)
                    }
                    return
                }
                
                self?.showList()
                self?.venuesToShow = venues
                self?.venuesTableView.reloadData()
            }
        }
    }
    
    // View functions
    
    func show(_ error: ErrorObject) {
        errorView.isHidden = false
        activityIndicator.stopAnimating()
        venuesTableView.isHidden = true
        
        errorLabel.text = error.messageBody
        errorImage.image = UIImage(named: error.imageName)
        self.errorCode = error.errorCode
        
        switch error.errorCode {
            case .InternetNotAvailable, .LocationAcceessDenied:
                // The framework handles the internet recovery
                retryBUtton.isHidden = true
        case .LocationNotFound: break
        default: break
        }
    }
    
    func showProgress() {
        errorView.isHidden = true
        activityIndicator.startAnimating()
        venuesTableView.isHidden = true
    }
    
    func showList() {
        errorView.isHidden = true
        activityIndicator.stopAnimating()
        venuesTableView.isHidden = false
    }
    
    func setBarButton() {
        switch appMode {
        case .Realtime:
            barItemButton.title = "Single Update"
        case .SingleUpdate:
            barItemButton.title = "Realtime"
        }
    }
    
    // IBActions
    
    @IBAction func retryButtonClicked() {
        switch errorCode {
        case .none:
            return
        case .some(.LocationAcceessDenied): break
        default: break
        }
    }
    
    @IBAction func barItemButtonClicked(_ sender: UIBarButtonItem) {
        switch appMode {
        case .Realtime:
            appMode = .SingleUpdate
            locationManager.stopUpdatingLocation()
        case .SingleUpdate:
            appMode = .Realtime
            locationManager.startUpdatingLocation()
        }
        userDefaults.set(appMode.rawValue, forKey: AppModeKey)
        setBarButton()
    }
}
