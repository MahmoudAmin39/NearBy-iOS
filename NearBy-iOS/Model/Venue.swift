//
//  Venue.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import Foundation

struct Venue {
    
    var id: String
    var name: String
    var address: String
    
    init?(with json: [String: Any]?) {
        if let json = json, let id = json["id"] as? String, let name = json["name"] as? String, let location = json["location"] as? [String: Any], let address = location["address"] as? String {
            self.name = name
            self.id = id
            self.address = address
            return
        }
        return nil
    }
}
