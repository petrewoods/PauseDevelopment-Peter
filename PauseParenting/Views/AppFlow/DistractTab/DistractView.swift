//
//  DistractView.swift
//  PauseParenting
//
//  Created by Peter Woods on 04/11/2023.
//



import SwiftUI

enum DistractGame: CaseIterable, Identifiable {
    var id: Self { self }
    case whatsThat, betYou, canYou, whatColour
    
    var title: String {
        switch self {
        case .whatsThat: "What's that over there"
        case .betYou: "Bet you can't do 10 star jumps"
        case .canYou: "Can you count these with me"
        case .whatColour:  "What colour is this?"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .whatsThat: Color.distract
        case .betYou: Color.white
        case .canYou: Color.white
        case .whatColour: Color.distract
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .whatsThat: Color.white
        case .betYou: Color.textDark
        case .canYou: Color.textDark
        case .whatColour: Color.white
        }
    }
}

struct DistractView: View {
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
                        
                    
                    Spacer()
                    IgnoreButton
                        
                    
                        
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
        Text("Distract")
            .font(.poppins700, size: 40)
            .foregroundStyle(Color.textDark)
    }
    
    private var buttonsGrid: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
                    let buttonSize = max((width / 2) - 20, 0) // Ensure buttonSize is not negative
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 20) {
                ForEach(DistractGame.allCases) { game in
                    RectangleGameButton(game: game, action: navigation(to:), width: buttonSize)
                        .frame(width: buttonSize, height: buttonSize)
                }
            }
            
        }
        //the height here is hard coded as it was making the minimum height small and ruining the formatting
        .frame(minHeight: 370)
    }

    
    private var infoText: some View {
        Text("If you can't ignore whining, crying or trantrums when nothing is physically wrong or hurting, don't react angrily, instead try to distract.")
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
    
    //this button doesn't yet work! ignore also doesn't exist
    
    private var IgnoreButton: some View {
        Button {
            //showFinalSheet = true
        } label: {
            Text("Try Ignore Instead")
            
        }
        .buttonStyle(.darkGrayButton)
        .padding()
    }
    
    
    private func navigation(to type: DistractGame) {
        switch type {
        case .whatsThat:
            dismiss.callAsFunction()
            onDismissAction = {
                navigationManager.homePath.append(DistractCardPathItem())
            }
        case .betYou:
            dismiss.callAsFunction()
            onDismissAction = {
                navigationManager.homePath.append(DistractCardPathItem())
            }
        case .canYou:
            dismiss.callAsFunction()
            onDismissAction = {
                navigationManager.homePath.append(DistractCardPathItem())
            }
        case .whatColour:
            dismiss.callAsFunction()
            onDismissAction = {
                navigationManager.homePath.append(DistractCardPathItem())
            }
        }
    }
    
}
fileprivate struct RectangleGameButton: View {
    let game: DistractGame
    let action: (DistractGame) -> ()
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
    DistractView()
        .environmentObject(NavigationManager())
        .environmentObject(ParentDataManager())
}
