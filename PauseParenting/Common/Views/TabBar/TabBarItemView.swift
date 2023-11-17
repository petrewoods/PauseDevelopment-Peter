//
//  TabBarItemView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 12.10.2023.
//

import SwiftUI

enum TabItem: Int, CaseIterable, Identifiable, Equatable {
    var id: RawValue { rawValue }
    
    case home, journal, settings
    
    var image: String {
        switch self {
        case .home: return "homeTabIcon"
        case .journal: return "journalTabIcon"
        case .settings: return "settingsTabIcon"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .journal: return "Journal"
        case .settings: return "Settings"
        }
    }
}

struct TabBarItemView: View {
    let tabItem: TabItem
    let isSelected: Bool
    let isPathEmpty: Bool
    var action: (TabItem) -> ()
    
    private var internalIsSelected: Bool {
        isSelected && isPathEmpty
    }
    
    var body: some View {
        Button {
            action(tabItem)
        } label: {
            VStack(spacing: 4) {
                Image(tabItem.image)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(internalIsSelected ? .mainOrange : .textDark)
                    .opacity(internalIsSelected ? 1 : 0.2)
                    .frame(width: 28, height: 28)
                
                Text(tabItem.title)
                    .font(internalIsSelected ? .poppins600 : .poppins400, size: 10)
                    .foregroundColor(internalIsSelected ? .mainOrange : .textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .animation(.easeIn.speed(1.25), value: internalIsSelected)
    }
}

struct TabBarVisibility: ViewModifier {
    @EnvironmentObject private var navigationManager: NavigationManager
    let visibility: Visibility
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                switch visibility {
                case .automatic: break
                case .visible: navigationManager.isTabBarHidden = false
                case .hidden: navigationManager.isTabBarHidden = true
                }
            }
    }
}

extension View {
    func tabBarVisibility(_ visibility: Visibility) -> some View {
        modifier(TabBarVisibility(visibility: visibility))
    }
}

#Preview {
    VStack {
        TabBarItemView(tabItem: .home, isSelected: true, isPathEmpty: true) {_ in}
        TabBarItemView(tabItem: .journal, isSelected: true, isPathEmpty: true) {_ in}
        TabBarItemView(tabItem: .settings, isSelected: false, isPathEmpty: true) {_ in}
    }
}
