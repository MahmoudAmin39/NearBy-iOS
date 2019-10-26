//
//  AppError.swift
//  NearBy-iOS
//
//  Created by Mahmoud Amin on 10/26/19.
//  Copyright © 2019 Mahmoud Amin. All rights reserved.
//

import Foundation

struct ErrorObject {
    var messageBody: String
    var imageName: String
    var errorCode: AppError
}

enum AppError: Error {
    case InternetNotAvailable
    case LocationAcceessDenied
    case LocationNotFound
}
