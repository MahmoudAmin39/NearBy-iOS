//
//  VenueTableViewCell.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import UIKit
import SDWebImage

class VenueTableViewCell: UITableViewCell {

    @IBOutlet weak var venueImageView: UIImageView!
    
    @IBOutlet weak var venueNameLabel: UILabel!
    
    @IBOutlet weak var venueAddressLabel: UILabel!
    
    var apiClient = PhotoApiClient()
    
    func bindViews(with venueData: Venue) {
        venueImageView.image = UIImage(named: "photo")
        venueNameLabel.text = venueData.name
        venueAddressLabel.text = venueData.address
        
        apiClient.getPhotoUrl(forVenue: venueData.id) { [weak self] url in
            guard let urlString = url else {
                self?.venueImageView.image = UIImage(named: "error")
                return
            }
            let url = URL(string: urlString)
            self?.venueImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "photo"))
        }
    }
}
