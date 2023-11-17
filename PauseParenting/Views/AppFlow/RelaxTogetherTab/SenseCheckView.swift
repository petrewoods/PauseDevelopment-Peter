//
//  SenseCheckView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 30.10.2023.
//

import SwiftUI

enum SenseCheckStep: Int, CaseIterable, Identifiable {
    case fiveFingers, fourFingers, threeFingers, twoFingers, oneFinger
    
    var id: String {
        return image
    }
    
    var image: String {
        switch self {
        case .oneFinger: "oneFingerImage"
        case .twoFingers: "twoFingersImage"
        case .threeFingers: "threeFingersImage"
        case .fourFingers: "fourFingersImage"
        case .fiveFingers: "fiveFingersImage"
        }
    }
    
    var number: String {
        switch self {
        case .oneFinger: "1"
        case .twoFingers: "2"
        case .threeFingers: "3"
        case .fourFingers: "4"
        case .fiveFingers: "5"
        }
    }
    
    var description: String {
        switch self {
        case .oneFinger: "Count 1 thing you can taste"
        case .twoFingers: "Count 2 things you can smell"
        case .threeFingers: "Count 3 things you can hear"
        case .fourFingers: "Count 4 things you can feel"
        case .fiveFingers: "Count 5 things you can see"
        }
    }
}

struct SenseCheckView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var parentData: ParentDataManager
        
    @State private var isStartSessionButtonPressed = false
    @State private var showingStartButton = true
    @State private var showingMainContent = false
    @State private var selectedTab = 0
    @State private var showingLastStep = false
    @State private var showFinalSheet = false
    
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 0) {
            title
            Spacer()
            
            Group {
                if showingMainContent {
                    stepsContent
                }
                
                if showingStartButton {
                    startSessionButton
                        .padding(.bottom, 100)
                        .transition(.move(edge: .bottom))
                        .frame(maxWidth: .infinity)
                }
                
                if showingLastStep {
                    finalInfoText
                    Spacer()
                    doneButton
                        .padding(.bottom, 50)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(
            background,
            alignment: .top
        )
        .overlay(
            xmarkButton,
            alignment: .topTrailing
        )
        .sheet(isPresented: $showFinalSheet) {
            WellDoneView()
        }
        .onAppear(perform: navigationManager.hideTabBar)
        .onDisappear(perform: navigationManager.showTabBar)
    }
    
    private var background: some View {
        Image("mainLargeBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var title: some View {
        Text("Sense check")
            .foregroundStyle(Color.black)
            .font(.poppins600, size: 18)
    }
    
    private var xmarkButton: some View {
        Button {
            navigationManager.removeLast()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .foregroundStyle(.black)
                .frame(width: 22, height: 22)
                .padding(.trailing, 30)
        }
    }
    
    private var startSessionButton: some View {
        VStack(spacing: 56) {
            Button {
                isStartSessionButtonPressed = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        showingStartButton = false
                        showingMainContent = true
                    }
                }
            } label: {
                Image("senseCheckIcon")
                    .renderingMode(.template)
                    .foregroundStyle(.white)
            }
            .buttonStyle(StartSessionButton(isButtonPressed: $isStartSessionButtonPressed))
            
            Text("Start")
                .font(.poppins400, size: 13)
                .foregroundStyle(.black)
        }
    }
    
    @ViewBuilder
    private var stepsContent: some View {
        let allSteps = SenseCheckStep.allCases
        
        TabView(selection: $selectedTab) {
            ForEach(0..<allSteps.count, id: \.self) { index in
                VStack(spacing: 20) {
                    Image(allSteps[index].image)
                        .frame(height: 400)
                    
                    Text(allSteps[index].number)
                        .foregroundStyle(Color.textDark)
                        .font(.poppins500, size: 36)
                        .padding(.top, 30)
                    
                    Text(allSteps[index].description)
                        .foregroundStyle(Color.textDark)
                        .font(.poppins400, size: 16)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .onAppear {
            startTimer()
        }
        .onDisappear(perform: stopTimer)
        .onChange(of: selectedTab) { tab in
            stopTimer()
            startTimer()
        }
    }
    
    private var finalInfoText: some View {
        VStack(spacing: 40) {
            Text("Now close your eyes and take a deep breath, and notice how you feel.")
            Text("Well done for taking the time to be present.")
            Text("Click done when you are ready.")
        }
        .foregroundStyle(Color.textDark)
        .font(.poppins400, size: 16)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
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

    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { _ in
            withAnimation {
                if selectedTab < SenseCheckStep.allCases.count - 1 {
                    selectedTab = selectedTab + 1
                } else {
                    showingMainContent = false
                    showingLastStep = true
                    stopTimer()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    SenseCheckView()
        .environmentObject(NavigationManager())
        .environmentObject(ParentDataManager())
}
