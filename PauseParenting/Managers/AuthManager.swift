//
//  AuthManager.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 31.10.2023.
//

import Foundation
import FirebaseAuth
import SwiftUI

class AuthManager: ObservableObject {
    static let userID = Auth.auth().currentUser?.uid
    
    @Published public var postcode = ""
    
    @Published private(set) var user: UserModel?
    @Published private(set) var child: ChildModel?
    
    @Published private(set) var isLoading = false
    @Published private(set) var isVerified = false
    @Published private(set) var isRegistered = false
    
    deinit {
        print("[Deinit] auth manager")
    }
    
    @MainActor
    public func isAuthorized() async -> Bool {
        do {
            let user = try await UserRepository.getCurrentUser()
            self.user = user
            
            return true
        } catch {
            print("[Error][AuthManager] isAuthorized: \(error)")
            return false
        }
    }
    
    public func verifyPostcode() {
        let preparedPostcode = postcode.postcodeFormat
        
        guard preparedPostcode.postcodeValid else {
            print("[Warning][AuthManager] postcode is not valid")
            return
        }
        
        isLoading = true
        
        Task { @MainActor in
            do {
                let authUser = try await AuthRepository.authUser(postcode: preparedPostcode)
                
                user = authUser
                isVerified = true
                isRegistered = authUser.isRegistered
                
                print("[Success][AuthManager] verified postcode. Registration status: \(isRegistered)")
            } catch {
                isVerified = false
                isRegistered = false
                
                print("[Error][AuthManager] unable to verify postcode: \(error)")
            }
            
            isLoading = false
        }
    }
    
    public func handleChildCreation(_ child: ChildModel, uiImage: UIImage?) { Task { @MainActor in
        do {
            var child = child
            
            if let uiImage {
                let id = (child.id ?? "") + "_" + UUID().uuidString
                ImageRepository.saveImage(uiImage, id: id)
                child.image = id
            }
            
            child = try await ChildRepository.createChild(child)
            self.child = child
        } catch {
            print("[Error][AuthManager] handleChildCreation: \(error)")
        }
    }}
    
    public func handleUserCreation(_ createdUser: UserModel, uiImage: UIImage?) { Task { @MainActor in
        do {
            var userToUpdate = createdUser
            userToUpdate.id = user?.id
            userToUpdate.postcode = user?.postcode ?? ""
            userToUpdate.children = [child?.id].compactMap { $0 }
            
            if let uiImage {
                let id = (userToUpdate.id ?? "") + "_" + UUID().uuidString
                ImageRepository.saveImage(uiImage, id: id)
                userToUpdate.image = id
            }
            
            try await UserRepository.updateUser(userToUpdate, merge: true)
            self.user = userToUpdate
        } catch {
            print("[Error][AuthManager] handleUserCreation: \(error)")
        }
    }}
    
    public static func logout() async throws {
        guard let user = Auth.auth().currentUser else { return }
        
        do {
            try await user.delete()
            try Auth.auth().signOut()
        } catch {
            print("[Error][AuthManager] logout: \(error)")
        }
    }
}


