//
//  NavigationManager.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 06.10.2023.
//

import Foundation
import SwiftUI

protocol PathItem: Hashable, Codable { }

enum AppState: Equatable {
    case launching, onboarding, authorized
}

enum OnboardingStep {
    case welcome, addChild, addParent, completed
}

final class NavigationManager: ObservableObject {
    @Published var tabBarSize = CGSize()
    @Published var appState = AppState.launching
    @Published var onboardingStep: OnboardingStep = .welcome
    
    @Published var onboardingPath = NavigationPath()
    @Published var isTabBarHidden = false
    @Published var selectedTab: TabItem = .home
    
    @Published var homePath = NavigationPath()
    @Published var journalPath = NavigationPath()
    @Published var settingsPath = NavigationPath()
    @Published var relaxTogetherPath = NavigationPath()
    @Published var ignorePath = NavigationPath()
    @Published var secondIgnorePath = NavigationPath()
    @Published var distractPath = NavigationPath()

    var isShowingTabBar: Bool = true
//    {
//        homePath.isEmpty
//        //[homePath, journalPath, settingsPath].allSatisfy(\.isEmpty)
//    }
    
    var isCurrentPathEmpty: Bool {
        switch appState {
        case .launching: return true
        case .onboarding: return onboardingPath.isEmpty
        case .authorized:
            switch selectedTab {
            case .home: return homePath.isEmpty
            case .journal: return journalPath.isEmpty
            case .settings: return settingsPath.isEmpty
            }
        }
    }
    
    func append<T: PathItem>(_ pathItem: T) {
        switch appState {
        case .launching: break
        case .onboarding: onboardingPath.append(pathItem)
        case .authorized:
            switch selectedTab {
            case .home: homePath.append(pathItem)
            case .journal: journalPath.append(pathItem)
            case .settings: settingsPath.append(pathItem)
            }
        }
    }
    
    func removeLast(_ k: Int = 1) {
        switch appState {
        case .launching: break
        case .onboarding: onboardingPath.removeLast(k)
        case .authorized:
            switch selectedTab {
            case .home: homePath.removeLast(k)
            case .journal: journalPath.removeLast(k)
            case .settings: settingsPath.removeLast(k)
            }
        }
    }
    
    func resetCurrentPath() {
        switch appState {
        case .launching: break
        case .onboarding: onboardingPath = NavigationPath()
        case .authorized:
            switch selectedTab {
            case .home: homePath = NavigationPath()
            case .journal: journalPath = NavigationPath()
            case .settings: settingsPath = NavigationPath()
            }
        }
    }
    
    func clearAllPaths() {
        onboardingPath = NavigationPath()
        homePath = NavigationPath()
        journalPath = NavigationPath()
        settingsPath = NavigationPath()
        relaxTogetherPath = NavigationPath()
        //ignorePath = NavigationPath()
        distractPath = NavigationPath()
        //secondIgnorePath = NavigationPath()
    }
    
    public func hideTabBar() {
        isTabBarHidden = true
    }
    
    public func showTabBar() {
        isTabBarHidden = false
    }
    
    func logout() {
        clearAllPaths()
        onboardingStep = .welcome
        selectedTab = .home
        appState = .onboarding
    }
}

struct SelectedModulesPathItem: PathItem { }
struct AboutTheAppPathItem: PathItem { }
struct HomeProfilesPathItem: PathItem { }
struct IgnoreViewPathItem: PathItem { }
struct PraiseViewPathItem: PathItem { }
struct DistractCardPathItem: PathItem { }
struct SecondIgnoreViewPathItem: PathItem { }

struct ParentDetailPathItem: PathItem {
    let parent: UserModel
}
struct ChildDetailPathItem: PathItem {
    let child: ChildModel
}
struct CalmBreathsPathItem: PathItem { }
struct SenseCheckPathItem: PathItem { }
struct BlowCandlesPathItem: PathItem { }

