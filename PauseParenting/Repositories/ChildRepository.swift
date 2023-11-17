//
//  ChildRepository.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 31.10.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChildRepository {
    static private let store = Firestore.firestore()
    static private var childrenListener: ListenerRegistration?
    
    static public func observeChildren(_ onUpdate: @escaping (Result<[ChildModel], Error>) -> ()) {
        guard let userID = Auth.auth().currentUser?.uid else {
            onUpdate(.failure(CustomError.userNotAuthorized))
            return
        }
        
        childrenListener?.remove()
        
        childrenListener = store
            .collection(.children)
            .whereField("parents", arrayContains: userID)
            .order(by: "date_created", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error {
                    onUpdate(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    onUpdate(.failure(CustomError.userNotExist))
                    return
                }
                
                let childs = documents.compactMap { child -> ChildModel? in
                    do {
                        let child = try child.data(as: ChildModel.self, customDecoder: true)
                        return child
                    } catch {
                        print("[Error][ChildRepository] observeChildren: \(error)")
                        return nil
                    }
                }
                
                onUpdate(.success(childs))
            }
    }
    
    static public func stopObserving() {
        childrenListener = nil
    }
    
    static public func updateChild(_ child: ChildModel, merge: Bool = false) async throws {
        guard let childID = child.id else { throw CustomError.emptyUserID }
        
        try await store
            .collection(.children)
            .document(childID)
            .setData(from: child, merge: merge)
    }
    
    static public func getChildren() async throws -> [ChildModel] {
        guard let userID = Auth.auth().currentUser?.uid else { throw CustomError.userNotAuthorized }
        
        return try await store
            .collection(.children)
            .whereField("parents", arrayContains: userID)
            .order(by: "date_created", descending: true)
            .getDocuments()
            .documents
            .compactMap { try? $0.data(as: ChildModel.self, customDecoder: true) }
    }
    
    @discardableResult
    static public func createChild(_ child: ChildModel) async throws -> ChildModel {
        guard let userID = Auth.auth().currentUser?.uid else { throw CustomError.userNotAuthorized }
        
        var child = child
        child.parents = [userID]
        
        let batch = store.batch()
        
        let childRef = store
            .collection(.children)
            .document()
        
        let userRef = store
            .collection(.users)
            .document(userID)
        
        try batch.setData(
            from: child,
            forDocument: childRef,
            encoder: .snakeEncoder
        )
        
        batch.updateData(
            ["children": FieldValue.arrayUnion([childRef.documentID])],
            forDocument: userRef
        )
        
        try await batch.commit()
        
        child.id = childRef.documentID
        return child
    }
    
    static public func deleteChild(_ child: ChildModel) async throws {
        guard let userID = Auth.auth().currentUser?.uid else { throw CustomError.userNotAuthorized }
        guard let childID = child.id, !childID.isEmpty else { throw CustomError.emptyUserID }
        
        let batch = store.batch()
        
        let childRef = store
            .collection(.children)
            .document(childID)
        
        let userRef = store
            .collection(.users)
            .document(userID)
        
        batch.deleteDocument(childRef)
        batch.updateData(
            ["children": FieldValue.arrayRemove([childID])],
            forDocument: userRef
        )
        
        try await batch.commit()
    }
}
