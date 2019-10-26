//
//  ViewModel.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import Foundation
import Alamofire

struct ViewModel {
    
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    
    func isInternetAvailable(with callback: @escaping (ErrorObject?) -> ()) {
        manager?.listener = { status in
            switch status {
            case .reachable(.ethernetOrWiFi):
                callback(nil)
            default:
                let error = ErrorObject(messageBody: "No internet Available", imageName: "image_cloud", errorCode: .InternetNotAvailable)
                callback(error)
            }
        }
        
        manager?.startListening()
    }
}

struct ErrorObject {
    var messageBody: String
    var imageName: String
    var errorCode: AppError
}

enum AppError: Error {
    case InternetNotAvailable
}
