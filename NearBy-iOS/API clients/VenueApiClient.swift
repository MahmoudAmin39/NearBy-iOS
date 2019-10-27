//
//  ApiClient.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

struct VenueApiClient {
    
    let baseUrl = "https://api.foursquare.com/v2/"
    let clientId = "ARGWPW5P3JAFNGBAHEG24M0BDCONDMI4U3YE5JALP2I0GYMB"
    let clientSecret = "E3CY4R2KFJDX3QN4KTBHMXWO4NKPLLLYY2F5YNKHOXPRPBJH"
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
    
    mutating func getVenues(of location: CLLocation, completion: @escaping ([Venue]?, ErrorObject?) -> ()) {
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        let latLong = "\(lat),\(long)"
        self.latLong = latLong
        
        // Send the request
        if let requestString = venuesRequest {
            guard let url = URL(string: requestString) else {
                let error = ErrorObject(messageBody: "Wrong request Url", imageName: "cloud", errorCode: .BadRequest)
                completion(nil, error)
                return
            }
            Alamofire.request(url).validate().responseJSON { response in
                guard response.result.isSuccess else {
                    let error = response.error!.localizedDescription
                    let errorObject = ErrorObject(messageBody: "Something went wrong !!: \(error)", imageName: "cloud", errorCode: .ServerResponseError)
                            completion(nil, errorObject)
                        return
                    }
                
                    guard let jsonResponse = response.result.value as? [String: Any],
                        let responseFromServer = jsonResponse["response"] as? [String: Any], let groups = responseFromServer["groups"] as? [Any], let group = groups.first as? [String: Any], let items = group["items"] as? [Any] else {
                            let error = ErrorObject(messageBody: "Error parsing the data", imageName: "cloud", errorCode: .JSONParseError)
                            completion(nil, error)
                            return
                    }
                    var venues = [Venue]()
                    _ = items.enumerated().map { (index, item) in
                        let castedItem = item as? [String: Any]
                        guard let newItem = castedItem else { return }
                        let venueJson = newItem["venue"] as? [String: Any]
                        let venue = Venue(with: venueJson)
                        guard let newVenue = venue else { return }
                        venues.append(newVenue)
                    }
                    completion(venues, nil)
            }
        }
    }
}
