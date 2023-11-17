//
//  CustomError.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 30.10.2023.
//

import Foundation

enum CustomError: Error {
    case userNotExist, userExist, userNotAuthorized, emptyUserID
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .userNotExist: NSLocalizedString(
            "User does not exist. Please check if the postcode is valid.",
            comment: ""
        )
        case .userExist: NSLocalizedString(
            "Unable to register the user. This postcode already exists.",
            comment: ""
        )
        case .userNotAuthorized: NSLocalizedString(
            "User is not authorized.",
            comment: ""
        )
        case .emptyUserID: NSLocalizedString(
            "UserID is empty.",
            comment: ""
        )
        }
    }
}
