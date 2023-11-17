//
//  ParentDataManager.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 31.10.2023.
//

import Foundation
import SwiftUI

class ParentDataManager: ObservableObject {
    @Published public var helpingChildren = ChildModel()
    
    @Published private(set) var parent: UserModel?
    @Published private(set) var children = [ChildModel]()
    
    @Published private(set) var parentLoading = true
    @Published private(set) var childrenLoading = true
    
    public func startObserving() {
        UserRepository.observeCurrentUser { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let user):
                self.parent = user
            case .failure(let error):
                print("[Error][AuthManager] observeCurrentUser: \(error)")
            }
            
            self.parentLoading = false
        }
        
        ChildRepository.observeChildren { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let children):
                self.children = children
                
                if self.childrenLoading, let children = children.first {
                    self.helpingChildren = children
                    self.childrenLoading = false
                } else if let child = children.first(where: { $0.id == self.helpingChildren.id }) {
                    self.helpingChildren = child
                }
            case .failure(let error):
                print("[Error][AuthManager] observeChildren: \(error)")
            }
        }
    }
    
    public func stopObserving() {
        UserRepository.stopObserving()
        ChildRepository.stopObserving()
        parentLoading = true
        childrenLoading = true
    }
    
    public func addChild(_ child: ChildModel, uiImage: UIImage?) { Task {
        do {
            var child = child
            if let uiImage {
                let id = (child.id ?? "") + "_" + UUID().uuidString
                ImageRepository.saveImage(uiImage, id: id)
                child.image = id
            }
            
            try await ChildRepository.createChild(child)
        } catch {
            print("[Error][ParentDataManager] addChild: \(error)")
        }
    }}
    
    public func updateUser(_ user: UserModel, uiImage: UIImage?) { Task {
        do {
            var user = user
            user.id = parent?.id ?? ""
            user.postcode = parent?.postcode ?? ""
            
            if let uiImage {
                let id = (user.id ?? "") + "_" + UUID().uuidString
                ImageRepository.saveImage(uiImage, id: id)
                user.image = id
            }
            
            try await UserRepository.updateUser(user)
        } catch {
            print("[Error][ParentDataManager] setupUser: \(error)")
        }
    }}
}
