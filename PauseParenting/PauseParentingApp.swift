//
//  PauseParentingApp.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 06.10.2023.
//

import SwiftUI
import Firebase

@main
struct PauseParentingApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.light)
        }
    }
}
