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
                        let responseFromServer = jsonResponse["response"] as? [String: Any], let groups = responseFromServer["groups"] as? [Any] else {
                            let error = ErrorObject(messageBody: "Error parsing the data", imageName: "cloud", errorCode: .JSONParseError)
                            completion(nil, error)
                            return
                    }
                
                    print(groups)
                    completion([Venue](), nil)
            }
        }
    }
}
