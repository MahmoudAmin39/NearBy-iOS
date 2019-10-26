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
    
    @IBOutlet weak var retryButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var venuesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        venuesTableView.dataSource = self
        
        errorView.isHidden = true
        activityIndicator.isHidden = true
        venuesTableView.isHidden = false
    }
    
    // TableView Implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

