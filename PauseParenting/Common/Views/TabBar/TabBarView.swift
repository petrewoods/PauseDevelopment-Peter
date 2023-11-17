//
//  TabBarView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 12.10.2023.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    private var bottomPadding: CGFloat { ScreenUtils.bottomBarHeight == 0 ? 8 : -6 }
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(TabItem.allCases) { tab in
                let isSelected = navigationManager.selectedTab == tab
                let isPathEmpty = isSelected ? navigationManager.isCurrentPathEmpty : true
                
                TabBarItemView(
                    tabItem: tab,
                    isSelected: isSelected,
                    isPathEmpty: isPathEmpty,
                    action: tabAction
                )
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 10)
        .padding(.bottom, bottomPadding)
        .transition(
          .move(edge: .bottom)
          .combined(with: .opacity)
        )
        .background { 
            VStack(spacing: 0){
                Divider()
                Color.white
            }
            .ignoresSafeArea()
        }
        .readSize { navigationManager.tabBarSize = $0 }
    }
    
    private func tabAction(_ tab: TabItem) {
        let isSelected = navigationManager.selectedTab == tab
        let isPathEmpty = isSelected ? navigationManager.isCurrentPathEmpty : true
        
        if isPathEmpty {
            navigationManager.selectedTab = tab
        } else {
            navigationManager.resetCurrentPath()
        }
    }
}

#Preview {
    VStack {
        Spacer()
        TabBarView()
    }
    .background(Color.blue.opacity(0.4))
    .environmentObject(NavigationManager())
}
