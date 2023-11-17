//
//  ProfilesView.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 18.10.2023.
//

import SwiftUI

struct ProfilesView: View {
    @EnvironmentObject private var parentData: ParentDataManager
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @State private var showingNewChild = false
    @State private var showingParentSetup = false
    
    var body: some View {
        VStack(spacing: 8) {
            header
            ScrollView {
                VStack(spacing: 52) {
                    profileSection
                    childsSection
                    createSection
                }
                .padding(.top, 8)
                .padding(.horizontal, 19)
            }
        }
        .background(Color.mainYellowBackground.ignoresSafeArea())
        .scrollBounceBehavior(.basedOnSize)
        .tabbarSafearea()
        .sheet(isPresented: $showingNewChild) {
            NewChildProfileView(
                isOnboarding: false,
                onCreate: parentData.addChild
            )
        }
        .sheet(isPresented: $showingParentSetup) {
            NewParentProfileView(
                isOnboarding: false,
                onCreate: parentData.updateUser
            )
        }
    }
    
    private var header: some View {
        //MARK: Replace by generic Navigation bar
        Text("Profiles")
            .font(.poppins700, size: 36)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .padding(.horizontal, 28)
            .padding(.top, 22)
            .foregroundStyle(Color.textDark)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var profileSection: some View {
        VStack(spacing: 10) {
            sectionTitle("YOUR PROFILE")
            
            let parent = parentData.parent
            ProfilesParentCellView(parent: parent) {
                if let parent, parent.isRegistered {
                    navigationManager.append(ParentDetailPathItem(parent: parent))
                } else {
                    showingParentSetup = true
                }
            }
        }
    }
    
    @ViewBuilder
    private var childsSection: some View {
        let children = parentData.children
        
        if !children.isEmpty {
            VStack(spacing: 10) {
                sectionTitle("CHILD PROFILES")
                ProfilesChildrenSectionView(children: parentData.children) { child in
                    navigationManager.append(ChildDetailPathItem(child: child))
                }
            }
        }
    }
    
    private var createSection: some View {
        ProfilesNewChildCard {
            showingNewChild = true
        }
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 12, weight: .regular))
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .foregroundStyle(Color.textSecondary)
            .padding(.horizontal, 22)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        ProfilesView()
            .environmentObject(NavigationManager())
            .environmentObject(ParentDataManager())
    }
}
