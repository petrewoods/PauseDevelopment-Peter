//
//  FirebaseExtension.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 30.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum Collection {
    case users
    case children
    
    var collection: String {
        switch self {
        case .users: "users"
        case .children: "children"
        }
    }
}

extension Firestore {
    func collection(_ collection: Collection) -> CollectionReference {
        self.collection(collection.collection)
    }
}

extension Firestore.Encoder {
    static let snakeEncoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        return encoder
    }()
}

extension Firestore.Decoder {
    static let snakeDecoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
}

extension DocumentReference {
    func setData<T: Encodable>(from value: T, merge: Bool = false, encoder: Firestore.Encoder = .snakeEncoder) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try setData(from: value, merge: merge, encoder: encoder) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

extension DocumentSnapshot {
    func data<T: Decodable>(
        as type: T.Type,
        with serverTimestampBehavior: ServerTimestampBehavior = .none,
        customDecoder: Bool = true
    ) throws -> T {
        let d: Any = data(with: serverTimestampBehavior) ?? NSNull()
        let decoder: Firestore.Decoder = customDecoder ? .snakeDecoder : .init()
        
        return try decoder.decode(T.self, from: d, in: reference)
  }
}

