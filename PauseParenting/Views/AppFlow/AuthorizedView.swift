//
//  AuthorizedView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 12.10.2023.
//

import SwiftUI

struct AuthorizedView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var parentData: ParentDataManager
    
    var body: some View {
        ZStack {
            switch navigationManager.selectedTab {
            case .home: HomeView()
            case .journal: JournalView()
            case .settings: SettingsView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mainOrange.opacity(0.4))
        .ignoresSafeArea(.keyboard)
        .addHideKeyboardButton()
        .tabbar(isPresented: navigationManager.isShowingTabBar && !navigationManager.isTabBarHidden)
        .onAppear(perform: parentData.startObserving)
        .onDisappear(perform: parentData.stopObserving)
    }
}

#Preview {
    AuthorizedView()
        .environmentObject(NavigationManager())
}
