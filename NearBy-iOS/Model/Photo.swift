//
//  Photo.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/27/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import Foundation

struct Photo {
    
    var id: String
    var prefix: String
    var suffix: String
    var fullUrl: String {
        get { return "\(prefix)100x100\(suffix)"}
    }
    var venueId: String
    
    init?(with json: [String: Any], forVenue id: String?) {
        if let photoId = json["id"] as? String, let prefix = json["prefix"] as? String,
            let suffix = json["suffix"] as? String, let venueId = id {
            self.id = photoId
            self.prefix = prefix
            self.suffix = suffix
            self.venueId = venueId
            return
        }
        return nil
    }
}
