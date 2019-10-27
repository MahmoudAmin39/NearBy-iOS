//
//  PhotoApiClient.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import Foundation
import Alamofire

struct PhotoApiClient {
    
    let baseUrl = "https://api.foursquare.com/v2/"
    let clientId = "HYRDE0P5SFIRQR0GSH5JS4SSRUG4KA23IWPDXFJK2TZVEV0R"
    let clientSecret = "NZ4JWFYPAYXRPYBZ0RYZZ3L5WKOPF2B2MIXLY0CUPGZUGV4S"
    let dateVersion = "20200101"
    var venueId: String?
    
    // https://api.foursquare.com/v2/venues/VENUE_ID/photos
    
    var photoRequest: String? {
        get {
            if let id = venueId {
                return "\(baseUrl)venues/\(id)/photos?client_id=\(clientId)&client_secret=\(clientSecret)&v=\(dateVersion)"
            } else {
                return nil
            }
        }
    }
    
    mutating func getPhotoUrl(forVenue id: String, completion: @escaping (String?) -> ()) {
        self.venueId = id
        // Send the request
        if let requestString = photoRequest {
            guard let url = URL(string: requestString) else {
                let _ = ErrorObject(messageBody: "Wrong request Url", imageName: "cloud", errorCode: .BadRequest)
                completion(nil)
                return
            }
            Alamofire.request(url).validate().responseJSON { response in
                guard response.result.isSuccess else {
                    let error = response.error!.localizedDescription
                    let _ = ErrorObject(messageBody: "Something went wrong !!: \(error)", imageName: "cloud", errorCode: .ServerResponseError)
                    completion(nil)
                    return
                }
                
                guard let jsonResponse = response.result.value as? [String: Any],
                    let responseFromServer = jsonResponse["response"] as? [String: Any], let photos = responseFromServer["photos"] as? [String: Any], let items = photos["items"] as? [Any], let photoJson = items.first as? [String: Any] else {
                        let _ = ErrorObject(messageBody: "Error parsing the data", imageName: "cloud", errorCode: .JSONParseError)
                        completion(nil)
                        return
                }
                
                let photo = Photo(with: photoJson, forVenue: id)
                completion(photo?.fullUrl)
            }
        }
    }
}
