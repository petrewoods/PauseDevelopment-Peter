//
//  RootView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 06.10.2023.
//

import SwiftUI

struct RootView: View {
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var authManager = AuthManager()
    @StateObject private var parentData = ParentDataManager()
    
    var body: some View {
        Group {
            switch navigationManager.appState {
            case .launching: SplashView()
            case .onboarding: WelcomeView()
            case .authorized: AuthorizedView()
            }
        }
        .environmentObject(navigationManager)
        .environmentObject(authManager)
        .environmentObject(parentData)
        .onAppear {
            onApearActions()
        }
    }
    
    
    //MARK: Methods
    private func onApearActions() { Task {
        if navigationManager.appState == .launching {
            let isAuth = await authManager.isAuthorized()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                navigationManager.appState = isAuth ? .authorized : .onboarding
            }
        }
    }}
}

#Preview {
    RootView()
}
