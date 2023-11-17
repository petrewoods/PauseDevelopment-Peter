//
//  ImageRepository.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 02.11.2023.
//

import Foundation
import SwiftUI

class ImageRepository {
    static private let store = UserDefaults.standard
    
    static func saveImage(_ uiImage: UIImage, id: String?) {
        guard let id, let jpegData = uiImage.jpegData(compressionQuality: 0.3) else {
            print("[Error][ImageRepository] save image: can't get jpeg data")
            return
        }
        
        let userID = id.components(separatedBy: "_")[0]
        
        var currentImages = store.value(forKey: UserDefaultsKeys.images.rawValue) as? [String: Data] ?? [:]
        let keys = currentImages.keys
        let userKey = keys.first(where: { $0.hasPrefix(userID) })
        
        if let userKey {
            currentImages[userKey] = nil
        }
        
        currentImages[id] = jpegData
        
        store.setValue(currentImages, forKey: UserDefaultsKeys.images.rawValue)
    }
    
    static func getImage(id: String?) -> UIImage? {
        guard let id else { return nil }
        
        let currentImages = store.value(forKey: UserDefaultsKeys.images.rawValue) as? [String: Data]
        
        if let currentImageData = currentImages?[id], let image = UIImage(data: currentImageData) {
            return image
        } else {
            return nil
        }
    }
}
