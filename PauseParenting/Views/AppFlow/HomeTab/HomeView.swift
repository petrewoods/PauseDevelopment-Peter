//
//  HomeView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 12.10.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var parentData: ParentDataManager
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @State private var selectedSection: GameSection?
    @State private var isChildPickerExpanded = false
    
    var body: some View {
        NavigationStack(path: $navigationManager.homePath) {
            ScrollView {
                VStack(spacing: 25) {
                    ChildPickerView(
                        selectedChild: $parentData.helpingChildren,
                        isExpanded: $isChildPickerExpanded,
                        children: parentData.children
                    )
                    .padding(.bottom, 20)
                    
                    Group {
                        letsStartText
                        cardsGrid
                    }
                    .blur(radius: isChildPickerExpanded ? 2 : 0)
                    .disabled(isChildPickerExpanded ? true : false)
                }
                .padding(.horizontal, 19)
                .padding(.top, 45)
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            .background(
                background,
                alignment: .top
            )
            .sheet(item: $selectedSection) { item in
                switch item {
                case .relaxTogether:
                    RelaxTogetherView()
                case .distract:
                    DistractView()
                case .ignore:                    IgnoreView()
                case .praise:                    PraiseView()
                default:
                    Text(item.title)
                        .presentationDetents([.height(300)])
                }

            }
            .navigationDestinations()
        }
    }
    
    private var background: some View {
        Image("mainLargeBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var letsStartText: some View {
        Text("Let’s Start")
            .foregroundStyle(Color.textDark)
            .font(.poppins700, size: 32)
            .padding(.horizontal, 9)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var cardsGrid: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 12) {
                ForEach(GameSection.allCases) { card in
                    Button {
                        onGameTap(card)
                    } label: {
                        CardView(sideSize: (geometry.size.width - 24) / 3, gameSection: card)
                    }
                }
            }
        }
    }
    
    private func onGameTap(_ type: GameSection) {
        switch type {
        case .timeOut: selectedSection = type
        case .quickTime: selectedSection = type
        case .relaxTogether: selectedSection = type
        case .distract: selectedSection = type
        case .ignore: navigationManager.append(IgnoreViewPathItem())
        case .praise: navigationManager.append(PraiseViewPathItem())
        case .chart: selectedSection = type
        case .profiles: navigationManager.append(HomeProfilesPathItem())
        case .consequences: selectedSection = type
        }
    }
}

fileprivate struct CardView: View {
    let sideSize: CGFloat
    let gameSection: GameSection
    
    var body: some View {
        VStack(spacing: 6) {
            icon
            cardTitle
        }
        .frame(width: sideSize, height: sideSize)
        .background(
            RoundedRectangle(cornerRadius: 27)
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 0)
        )
    }
    
    private var icon: some View {
        Image(gameSection.image)
            .frame(width: 45, height: 45)
    }
    
    private var cardTitle: some View {
        Text(gameSection.title)
            .foregroundStyle(Color.textDark)
            .font(.poppins500, size: gameSection.fontSize)
    }
    
    private var profilePicker: some View {
        HStack {
            Image("")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationManager())
}
