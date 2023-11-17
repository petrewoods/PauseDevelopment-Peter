//
//  DistractCardView.swift
//  PauseParenting
//
//  Created by Peter Woods on 04/11/2023.
//



import SwiftUI

struct CustomCard {
    var title: String
    var backgroundColor: Color
    var foregroundColor: Color
}


enum DistractCardGame: CaseIterable, Identifiable {
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
        case .canYou: Color.distract
        case .whatColour: Color.white
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .whatsThat: Color.white
        case .betYou: Color.textDark
        case .canYou: Color.white
        case .whatColour: Color.textDark
        }
    }
}


struct DistractCardView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var parentData: ParentDataManager
        
    
    @State private var showFinalSheet = false
    @State private var showInfoAlert: AlertType?
    @State private var customCards: [CustomCard] = []
    @State private var showingAddCardView = false
    

    var body: some View {
            VStack(spacing: 0) {
                title
                            Spacer()
                            
                            // TabView with a special card for adding new cards
                            TabView {
                                ForEach(DistractCardGame.allCases) { game in
                                    GameCardView(game: game)
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.65, maxHeight: UIScreen.main.bounds.width * 0.65)
                                        .background(game.backgroundColor)
                                        .cornerRadius(27)
                                }
                                
                                // Add Card Card
                                Button(action: { showingAddCardView = true }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 27)
                                            .fill(Color.gray.opacity(0.5)) // Give it a distinct look or match your design
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.65, maxHeight: UIScreen.main.bounds.width * 0.65)
                                        
                                        VStack {
                                            Image(systemName: "plus.circle.fill") // An icon to indicate adding something new
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.white)
                                            Text("Add New Card")
                                                .foregroundColor(.white)
                                                .font(.system(size: 24, weight: .medium))
                                        }
                                    }
                                }
                                .sheet(isPresented: $showingAddCardView) {
                                    AddCardView { newCard in
                                        customCards.append(newCard)
                                    }
                                }
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.65, maxHeight: UIScreen.main.bounds.width * 0.65)
                                .background(Color.gray.opacity(0.5))
                                .cornerRadius(27)
                                
                                // Custom Cards
                                ForEach(customCards.indices, id: \.self) { index in
                                    CustomGameCardView(customCard: customCards[index])
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.65, maxHeight: UIScreen.main.bounds.width * 0.65)
                                        .background(customCards[index].backgroundColor)
                                        .cornerRadius(27)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            .frame(height: UIScreen.main.bounds.width)
                
                doneButton
                    .padding(.bottom, 20)
                            Spacer()
                    .sheet(isPresented: $showFinalSheet) {
                                WellDoneDistractView()
                            }
                
                        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .background(
            background,
            alignment: .top
        )
        .overlay(
            xmarkButton,
            alignment: .topLeading
        )
//        .overlay(
//            Text("Would you like to do a relax activity with me"),
//            alignment: .topTrailing
//        )
        
        
//        .sheet(isPresented: $showFinalSheet) {
//            WellDoneView()
//        }
        .showAlert($showInfoAlert)
        .onAppear(perform: navigationManager.hideTabBar)
        .onDisappear(perform: navigationManager.showTabBar)
    }
    
    private var doneButton: some View {
        Button {
            showFinalSheet = true
        } label: {
            Text("Done")
        }
        .buttonStyle(.darkGrayButton)
        .padding(.horizontal)
    }
    
    private var background: some View {
        Image("mainLargeBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var title: some View {
        Text("Distract")
            .foregroundStyle(Color.black)
            .font(.poppins600, size: 18)
    }
    
    private struct GameCardView: View {
            let game: DistractCardGame
            
            var body: some View {
                ZStack {
                    RoundedRectangle(cornerRadius: 27)
                        .fill(game.backgroundColor)
                    
                    Text(game.title)
                        .foregroundColor(game.foregroundColor)
                        .font(.system(size: 24, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
    
    
        
    
    private var xmarkButton: some View {
        Button {
            navigationManager.removeLast()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 17, height: 17)
                .padding(.leading, 30)
                
        }
        .padding(.top, 5)
    }
    
    
}
    
    fileprivate struct RectangleGameButton: View {
        let game: DistractCardGame
        
        let width: CGFloat
        
        @ViewBuilder
        var body: some View {
            if width >= 0 {
                 
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
                            .padding(10)
                    }
                
            }
        }
    }

private struct CustomGameCardView: View {
        let customCard: CustomCard
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 27)
                    .fill(customCard.backgroundColor)
                
                Text(customCard.title)
                    .foregroundColor(customCard.foregroundColor)
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }

// View to add a new card
struct AddCardView: View {
    @State private var title: String = ""
    var addCard: (CustomCard) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card Details")) {
                    TextField("Card Title", text: $title)
                }
                
                Section {
                    Button("Add Card") {
                        let newCard = CustomCard(title: title, backgroundColor: .distract, foregroundColor: .textDark)
                        addCard(newCard)
                        dismiss()
                    }
                }
            }
            .navigationTitle("New Card")
        }
    }
}

#Preview {
    DistractCardView()
        .environmentObject(NavigationManager())
        .environmentObject(ParentDataManager())
}
