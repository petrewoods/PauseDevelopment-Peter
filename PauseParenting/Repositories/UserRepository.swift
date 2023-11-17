//
//  UserRepository.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 30.10.2023.
//

import Firebase
import FirebaseFirestoreSwift

class UserRepository {
    static private let store = Firestore.firestore()
    
    static private var userListener: ListenerRegistration?
    
    static public func observeCurrentUser(_ onUpdate: @escaping (Result<UserModel, Error>) -> ()) {
        guard let userID = Auth.auth().currentUser?.uid else {
            onUpdate(.failure(CustomError.userNotAuthorized))
            return
        }
        
        userListener?.remove()
        
        userListener = store
            .collection(.users)
            .document(userID)
            .addSnapshotListener { document, error in
                if let error {
                    onUpdate(.failure(error))
                    return
                }
                
                guard let document else {
                    onUpdate(.failure(CustomError.userNotExist))
                    return
                }
                
                do {
                    let user = try document.data(as: UserModel.self, customDecoder: true)
                    onUpdate(.success(user))
                } catch {
                    onUpdate(.failure(error))
                }
            }
    }
    
    static public func stopObserving() {
        userListener = nil
    }
    
    static public func getCurrentUser() async throws -> UserModel {
        guard let userID = Auth.auth().currentUser?.uid else { throw CustomError.userNotAuthorized }
        
        let userDocument = try await store
            .collection(.users)
            .document(userID)
            .getDocument()
        
        guard userDocument.exists else {
            throw CustomError.userNotExist
        }
        
        return try userDocument.data(as: UserModel.self, customDecoder: true)
    }
    
    static public func createUser(postcode: String) async throws -> UserModel {
        guard let userID = Auth.auth().currentUser?.uid else { throw CustomError.userNotAuthorized }
        
        let userDocument = try await store
            .collection(.users)
            .document(userID)
            .getDocument()
    
        if userDocument.exists {
            throw CustomError.userExist
        }
        
        let user = UserModel(userID: userID, postcode: postcode)
        
        try await userDocument
            .reference
            .setData(from: user)
        
        return user
    }
    
    static public func updateUser(_ user: UserModel, merge: Bool = false) async throws {
        guard let userID = user.id, !userID.isEmpty else { throw CustomError.emptyUserID }
        
        try await store
            .collection(.users)
            .document(userID)
            .setData(from: user, merge: merge)
    }
    
    static public func deleteUser(_ user: UserModel) async throws {
        guard let userID = Auth.auth().currentUser?.uid else { throw CustomError.userNotAuthorized }
        
        let batch = store.batch()
        
        let userRef = store
            .collection(.users)
            .document(userID)
        
        let childrenRefs = user.children.map {
            store
                .collection(.children)
                .document($0)
        }
        
        batch.deleteDocument(userRef)
        for childRef in childrenRefs {
            batch.deleteDocument(childRef)
        }
        
        try await batch.commit()
    }
    
    static public func updateRegisterState(_ state: Bool) async throws {
        guard let userID = Auth.auth().currentUser?.uid else { throw CustomError.userNotAuthorized }
        
        try await store
            .collection(.users)
            .document(userID)
            .updateData(["isRegistered": state])
    }
}
