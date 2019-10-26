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
    
    init(with json: Dictionary<String, Any>) {
        id = ""
        name = ""
        address = ""
    }
}
