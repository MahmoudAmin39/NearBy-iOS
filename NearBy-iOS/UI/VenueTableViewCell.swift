//
//  VenueTableViewCell.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {

    @IBOutlet weak var venueImageView: UIImageView!
    
    @IBOutlet weak var venueNameLabel: UILabel!
    
    @IBOutlet weak var venueAddressLabel: UILabel!
    
    func bindViews(with venueData: Venue) {
        venueImageView.image = UIImage(named: "photo")
        venueNameLabel.text = venueData.name
        venueAddressLabel.text = venueData.address
    }
}
