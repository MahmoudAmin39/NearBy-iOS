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
    
    @IBOutlet weak var errorView: UIStackView!
    
    @IBOutlet weak var errorImage: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var venuesTableView: UITableView!
    
    @IBOutlet weak var retryBUtton: UIButton!
    
    let networkReachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    let locationManager = CLLocationManager()
    var errorCode: AppError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegates
        venuesTableView.dataSource = self
        locationManager.delegate = self
        
        // Check internet
        networkReachabilityManager?.listener = { status in
            switch status {
            case .reachable(.ethernetOrWiFi):
                self.locationManager.requestWhenInUseAuthorization()
            default:
                // No internet
                let error = ErrorObject(messageBody: "No internet Available", imageName: "cloud", errorCode: .InternetNotAvailable)
                self.showError(error: error)
            }
        }
        // Listen to network changes
        networkReachabilityManager?.startListening()
    }
    
    // TableView Implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            // TODO: Get the location
            break
        case .denied, .restricted:
            showError(error: ErrorObject(messageBody: "Please grant the accees to location for the app to work properly", imageName: "location", errorCode: .LocationAcceessDenied))
            errorCode = .LocationAcceessDenied
        default: break
        }
    }
    
    // Visibility manipulation
    
    func showError(error: ErrorObject) {
        errorView.isHidden = false
        activityIndicator.isHidden = true
        venuesTableView.isHidden = true
        
        errorLabel.text = error.messageBody
        errorImage.image = UIImage(named: error.imageName)
        self.errorCode = error.errorCode
        
        switch error.errorCode {
            case .InternetNotAvailable, .LocationAcceessDenied:
                // The framework handles the internet recovery
                retryBUtton.isHidden = true
        }
    }
    
    func showProgress() {
        errorView.isHidden = true
        activityIndicator.isHidden = false
        venuesTableView.isHidden = true
    }
    
    func showList() {
        errorView.isHidden = true
        activityIndicator.isHidden = true
        venuesTableView.isHidden = false
    }
    
    @IBAction func retryButtonClicked() {
        switch errorCode {
        case .none:
            return
        case .some(.LocationAcceessDenied): break
        default: break
        }
    }
    
}
