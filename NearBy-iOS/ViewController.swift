//
//  ViewController.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var errorView: UIStackView!
    
    @IBOutlet weak var errorImage: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var venuesTableView: UITableView!
    
    @IBOutlet weak var retryBUtton: UIButton!
    
    
    // Internet clouser callback
    var internetClosure: ((ErrorObject?) -> ())?
    
    let viewModel = ViewModel()
    
    var errorCode: AppError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        venuesTableView.dataSource = self
        showProgress()
        
        internetClosure = { error in
            guard let error = error else {
                self.showProgress()
                return
            }
            // No internet
            self.showError(error: error)
        }
        
        if let internetClosure = internetClosure {
            viewModel.isInternetAvailable(with: internetClosure)
        }
    }
    
    // TableView Implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
        case .InternetNotAvailable:
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
        default: break
        }
    }
    
}
