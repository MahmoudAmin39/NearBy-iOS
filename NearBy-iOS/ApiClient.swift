//
//  ApiClient.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import Foundation
import CoreLocation

struct ApiClient {
    
    let baseUrl = "https://api.foursquare.com/v2/"
    let clientId = "5AAKGAAOYCKET3DK3IRT42YQOBP50EGTJU4S0U1P1GE3QEI5"
    let clientSecret = "WVTGKRKUHSEFTCHYVUWBDTOJRQZXROA5WIE3LJBL3MX0U0TJ"
    let dateVersion = "20200101"
    var latLong: String?
    
    var venuesRequest: String? {
        get {
            if let latLong = latLong {
                return "\(baseUrl)venues/explore?ll=\(latLong)&client_id=\(clientId)&client_secret=\(clientSecret)&v=\(dateVersion)"
            } else {
                return nil
            }
        }
    }
    
    mutating func getVenues(of location: CLLocation, completion: ([Venue]?, ErrorObject?) -> ()) {
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        let latLong = "\(lat),\(long)"
        self.latLong = latLong
        print(venuesRequest?.description)
    }
}
