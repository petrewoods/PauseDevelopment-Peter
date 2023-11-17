//
//  CalmBreathsView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 23.10.2023.
//

import SwiftUI

struct CalmBreathsView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var parentData: ParentDataManager
    
    @State private var showingStartButton = true
    @State private var currentTextIndex = 0
    @State private var timer: Timer?
    @State private var isCircleExpanded = false
    @State private var sessionFinished = false
    @State private var isStartSessionButtonPressed = false
    @State private var showFinalSheet = false
    
    let textElements = ["You and your child can use the timer to calm your breathing down together", "As the green circle expands take a deep breath in", "Hold your breath as the green circle stays big", "As the green circle shrinks, breath out slowly through your mouth", "Hold your breath as the green circle stays small. Breath in when it grows again."]
    
    var body: some View {
        VStack(spacing: 0) {
            title
            Spacer()
            
            BreathCircleView(isExpanded: $isCircleExpanded)
            
            Spacer()
            
            Group {
                startSessionButton
                    .offset(y: showingStartButton ? 0 : 300)
                    .frame(maxWidth: .infinity)
                
                if !showingStartButton && !sessionFinished {
                    tipText
                        .padding(.top, -150)
                        .padding(.bottom, 50)
                }
                if sessionFinished {
                    doneButton
                        .padding(.bottom, 20)
                }
            }
            .frame(height: 120)
            
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
        .onDisappear(perform: stopTimer)
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
        Text("Calm Breaths")
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
                        isCircleExpanded = true
                        showingStartButton = false
                    }
                    startTimer()
                }
            } label: {
                Image("relaxTogetherIcon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 37)
            }
            .buttonStyle(StartSessionButton(isButtonPressed: $isStartSessionButtonPressed))
            
            Text("Start")
                .font(.poppins400, size: 13)
                .foregroundStyle(.black)
        }
    }
    
    private var tipText: some View {
        Text(textElements[currentTextIndex])
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.textDark)
            .font(.poppins600, size: 18)
            .frame(height: 150)
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
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation {
                if currentTextIndex >= textElements.count - 1 {
                    sessionFinished = true
                    stopTimer()
                } else {
                    currentTextIndex += 1
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

fileprivate struct BreathCircleView: View {
    @Binding var isExpanded: Bool
    
    @State private var actualCircleSize: CGFloat = 100
    
    var body: some View {
        ZStack {
            background
            circleStroke
            mainCircle
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: isExpanded) { isExpanded in
            if isExpanded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.spring(duration: 3.5).repeatForever(autoreverses: true)) {
                        actualCircleSize = 240
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var background: some View {
        let width: CGFloat = isExpanded ? 264 : 72
        Rectangle()
            .foregroundStyle(.white)
            .frame(width: width, height: width)
    }
    
    @ViewBuilder
    private var circleStroke: some View {
        let radius: CGFloat = isExpanded ? 264 : 72
        Circle()
            .strokeBorder(.black, lineWidth: isExpanded ? 4 : 2)
            .frame(width: radius, height: radius)
    }
    
    @ViewBuilder
    private var mainCircle: some View {
        let radius = isExpanded ? actualCircleSize : 30
        Circle()
            .foregroundStyle(Color.mintGreen)
            .frame(width: radius, height: radius)
    }
}

#Preview {
    CalmBreathsView()
        .environmentObject(NavigationManager())
        .environmentObject(ParentDataManager())
}
