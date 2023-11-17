//
//  AuthRepository.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 30.10.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class AuthRepository {
    static private let store = Firestore.firestore()
    
    public static func authUser(postcode: String) async throws -> UserModel {
        do {
            try await Auth.auth().signInAnonymously()
            let user = try await UserRepository.getCurrentUser()
            return user
        } catch CustomError.userNotExist {
            let user = try await UserRepository.createUser(postcode: postcode)
            return user
        } catch {
            throw error
        }
    }
}
