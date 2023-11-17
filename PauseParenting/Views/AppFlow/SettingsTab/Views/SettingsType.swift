//
//  SettingsType.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 19.10.2023.
//

import Foundation
import SwiftUI

enum SettingType: String, CaseIterable, Identifiable, Equatable {
    var id: Self { self }
    case selectedModules, display, aboutTheApp, aboutTheDevelopers
    
    var title: String {
        switch self {
        case .selectedModules: "Selected Modules"
        case .display: "Display"
        case .aboutTheApp: "About The App"
        case .aboutTheDevelopers: "About The Developers"
        }
    }
    
    var description: String {
        switch self {
        case .selectedModules: ""
        case .display: "Description"
        case .aboutTheApp: ""
        case .aboutTheDevelopers: ""
        }
    }
    
    var imageName: String {
        switch self {
        case .selectedModules: "homeTabIcon"
        case .display: "bellIcon"
        case .aboutTheApp: ""
        case .aboutTheDevelopers: ""
        }
    }
    
    var imageColor: Color {
        switch self {
        case .selectedModules: .black
        case .display: .blueAction
        case .aboutTheApp: .blueAction
        case .aboutTheDevelopers: .blueAction
        }
    }
    
    var isRightChevron: Bool {
        switch self {
        case .selectedModules: true
        case .display: false
        case .aboutTheApp: false
        case .aboutTheDevelopers: false
        }
    }
    
    static let firstSection: [SettingType] = [.selectedModules, .display, .display]
    static let secondSection: [SettingType] = [.aboutTheApp, .aboutTheDevelopers, .display]
}
