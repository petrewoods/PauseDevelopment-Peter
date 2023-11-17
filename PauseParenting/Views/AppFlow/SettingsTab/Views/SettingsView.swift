//
//  SettingsView.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 18.10.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        NavigationStack(path: $navigationManager.settingsPath) {
            VStack(spacing: 8) {
                settingsText
                contentList
            }
            .background(Color.mainYellowBackground)
            .navigationDestinations()
        }
    }
    
    private var settingsText: some View {
        Text("Settings")
            .foregroundStyle(Color.textDark)
            .font(.poppins700, size: 36)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.top, 22)
    }
    
    private var contentList: some View {
        List {
            Section(header: Text("Title")) {
                ForEach(SettingType.firstSection) { type in
                    SettingCell(type: type, action: navigation(to:))
                }
            }
            Section(header: Text("Title")) {
                ForEach(SettingType.secondSection) { type in
                    SettingCell(type: type, action: navigation(to:))
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.mainYellowBackground.ignoresSafeArea())
    }
    
    private func navigation(to type: SettingType) {
        switch type {
        case .selectedModules:
            navigationManager.settingsPath.append(SelectedModulesPathItem())
        case .display:
            print("nav to display screen")
        case .aboutTheApp:
            navigationManager.settingsPath.append(AboutTheAppPathItem())
        case .aboutTheDevelopers:
            print("nav to about developers screen")
        }
    }
}

struct SettingCell: View {
    let type: SettingType
    let action: (SettingType) -> ()
    
    var body: some View {
        Button {
            action(type)
        } label: {
            HStack(spacing: 10) {
                image
                VStack(alignment: .leading) {
                    title
                    if !type.description.isEmpty {
                        description
                    }
                }
                .padding(.leading, type.imageName.isEmpty ? 30 : 0)
                if type.isRightChevron {
                    Spacer()
                    Image("rightArrowIcon")
                }
            }
            .contentShape(Rectangle())
        }
    }
    
    private var image: some View {
        Image(type.imageName)
            .colorMultiply(type.imageColor)
            .padding(.vertical, 5)
    }
  
    private var title: some View {
        Text(type.title)
            .foregroundStyle(Color.textDark)
            .font(.poppins400, size: 17)
    }
    
    private var description: some View {
        Text(type.description)
            .foregroundStyle(Color.textSecondary)
            .font(.poppins400, size: 12)
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationManager())
}
