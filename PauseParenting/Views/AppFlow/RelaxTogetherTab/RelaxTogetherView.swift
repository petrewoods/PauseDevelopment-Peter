//
//  RelaxTogetherView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 23.10.2023.
//

import SwiftUI

enum RelaxTogetherGame: CaseIterable, Identifiable {
    var id: Self { self }
    case calmBreaths, senseCheck, blowOutCandles, empty
    
    var title: String {
        switch self {
        case .calmBreaths: "Calm Breaths"
        case .senseCheck: "Sense Check"
        case .blowOutCandles: "Blow out the candles"
        case .empty:  "-"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .calmBreaths: Color.relaxBlueBackground
        case .senseCheck: Color.white
        case .blowOutCandles: Color.white
        case .empty: Color.relaxBlueBackground
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .calmBreaths: Color.white
        case .senseCheck: Color.textDark
        case .blowOutCandles: Color.textDark
        case .empty: Color.white
        }
    }
}

struct RelaxTogetherView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var navigationManager: NavigationManager
        
    @State private var isInfoExpanded = false
    @State private var onDismissAction: () -> () = {}
    
    var body: some View {
        NavigationStack(path: $navigationManager.homePath) {
            ScrollView {
                VStack(spacing: 0) {
                    if !isInfoExpanded {
                        HStack {
                            doneButton
                            Spacer()
                            infoButton
                        }
                    }
                    
                    title
                        .padding(.vertical, 50)
                    
                    if isInfoExpanded {
                        infoText
                            .padding(.horizontal)
                        okButton
                            .padding(.vertical, 50)
                    }
                    
                    buttonsGrid
                        .blur(radius: isInfoExpanded ? 2.0 : 0.0)
                        .disabled(isInfoExpanded ? true : false)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
            .navigationDestinations()
            .background(
                background,
                alignment: .top
            )
            .onDisappear(perform: onDismissAction)
        }
    }
    
    private var background: some View {
        Image("secondaryLargeBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var doneButton: some View {
        Button{
            dismiss.callAsFunction()
        } label: {
            Text("Done")
                .foregroundStyle(Color.blueAction)
                .font(.poppins400, size: 16)
        }
    }
    
    private var infoButton: some View {
        Button {
            withAnimation {
                isInfoExpanded = true
            }
        } label: {
            Text("Info")
                .foregroundStyle(Color.blueAction)
                .font(.poppins500, size: 16)
        }
    }
    
    private var title: some View {
        Text("Relax Together")
            .font(.poppins700, size: 40)
            .foregroundStyle(Color.textDark)
    }
    
    private var buttonsGrid: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 20) {
                ForEach(RelaxTogetherGame.allCases) { game in
                    RectangleGameButton(game: game, action: navigation(to:), width: proxy.size.width / 2 - 20)
                }
            }
        }
    }
    
    private var infoText: some View {
        Text("Try doing a relaxing activity with your child. Don't wait until somebody is upset.")
            .foregroundStyle(Color.textDark)
            .font(.poppins600, size: 18)
            .multilineTextAlignment(.center)
    }
    
    private var okButton: some View {
        Button {
            withAnimation {
                isInfoExpanded = false
            }
        } label: {
            Text("Ok")
                .font(.poppins400, size: 16)
                .foregroundStyle(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 32)
                .background(
                    RoundedRectangle(cornerRadius: 43)
                        .foregroundStyle(Color.blueAction)
                )
        }
    }
    
    
    private func navigation(to type: RelaxTogetherGame) {
        switch type {
        case .calmBreaths:
            dismiss.callAsFunction()
            onDismissAction = {
                navigationManager.homePath.append(CalmBreathsPathItem())
            }
        case .senseCheck:
            dismiss.callAsFunction()
            onDismissAction = {
                navigationManager.homePath.append(SenseCheckPathItem())
            }
        case .blowOutCandles:
            dismiss.callAsFunction()
            onDismissAction = {
                navigationManager.homePath.append(BlowCandlesPathItem())
            }
        case .empty:
            break
        }
    }
}

fileprivate struct RectangleGameButton: View {
    let game: RelaxTogetherGame
    let action: (RelaxTogetherGame) -> ()
    let width: CGFloat
    
    @ViewBuilder
    var body: some View {
        if width >= 0 {
            Button {
                action(game)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 27)
                        .foregroundStyle(game.backgroundColor)
                        .frame(width: width, height: width)
                        .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 4)
                    
                    Text(game.title)
                        .foregroundStyle(game.foregroundColor)
                        .font(.poppins600, size: 24)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.7)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    RelaxTogetherView()
        .environmentObject(NavigationManager())
        .environmentObject(ParentDataManager())
}
