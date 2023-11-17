//
//  BlowOutTheCandlesView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 30.10.2023.
//

import SwiftUI

struct FiredCandles: Hashable {
    var blownOut: Bool
    let xOffset: CGFloat
    let yOffset: CGFloat
    let rotatedDeegres: Double
    
    static var defaultCandles: [FiredCandles] {
        [
            FiredCandles(blownOut: false, xOffset: 124, yOffset: 5, rotatedDeegres: 4.2),
            FiredCandles(blownOut: false, xOffset: 192, yOffset: 6, rotatedDeegres: 11.5),
            FiredCandles(blownOut: false, xOffset: 95, yOffset: 98, rotatedDeegres: -1.9),
            FiredCandles(blownOut: false, xOffset: 155, yOffset: 96, rotatedDeegres: 4.2),
            FiredCandles(blownOut: false, xOffset: 225, yOffset: 97, rotatedDeegres: 13.5),
            FiredCandles(blownOut: false, xOffset: 26, yOffset: 205, rotatedDeegres: -7),
            FiredCandles(blownOut: false, xOffset: 98, yOffset: 200, rotatedDeegres: 0),
            FiredCandles(blownOut: false, xOffset: 157, yOffset: 197, rotatedDeegres: 4.2),
            FiredCandles(blownOut: false, xOffset: 222, yOffset: 199, rotatedDeegres: 9.8),
            FiredCandles(blownOut: false, xOffset: 295, yOffset: 208, rotatedDeegres: 18.4)
        ]
    }
}

struct BlowOutTheCandlesView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var parentData: ParentDataManager
        
    @State private var candles: [FiredCandles] = FiredCandles.defaultCandles
    @State private var showFinalSheet = false
    @State private var showInfoAlert: AlertType?
    
    var body: some View {
        VStack(spacing: 0) {
            title
            Spacer()
            tipText
            Spacer()
            fullCake
                .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .background(
            background,
            alignment: .top
        )
        .overlay(
            xmarkButton,
            alignment: .topLeading
        )
        .overlay(
            infoButton,
            alignment: .topTrailing
        )
        .onChange(of: candles) { newStates in
            if newStates.filter({ !$0.blownOut }).count <= 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showFinalSheet = true
                }
            }
        }
        .sheet(isPresented: $showFinalSheet) {
            WellDoneView()
        }
        .showAlert($showInfoAlert)
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
        Text("Blow out the candles")
            .foregroundStyle(Color.black)
            .font(.poppins600, size: 18)
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
    
    private var infoButton: some View {
        Button {
            showInfoAlert = .blowOutTheCandlesInfo
        } label: {
            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 31, height: 30)
                .padding(.trailing, 30)
                .padding(.top, -3)
        }
        .opacity(candles.allSatisfy { !$0.blownOut } ? 1 : 0)
    }
    
    private var fullCake: some View {
        ZStack(alignment: .topLeading) {
            cakeImage
            
            ForEach(candles, id: \.self) { candle in
                Image("smallFireImage")
                    .resizable()
                    .rotationEffect(.degrees(candle.rotatedDeegres))
                    .frame(width: 24, height: 32)
                    .offset(x: candle.xOffset, y: candle.yOffset)
                    .opacity(candle.blownOut ? 0 : 1)
            }
        }
        // TEMPORARY
        .onTapGesture {
            guard !candles.isEmpty else { return }
            
            withAnimation(.spring(duration: 0.2)) {
                let index = candles.firstIndex(where: {$0.blownOut != true}) ?? 0
                
                candles[index].blownOut = true
            }
        }
    }
    
    private var cakeImage: some View {
        Image("emptyCakeImage")
            .resizable()
            .scaledToFit()
            .frame(width: 340)
    }
    
    private var tipText: some View {
        Text(setupNewTip())
            .foregroundStyle(.black)
            .font(.poppins600, size: 24)
            .multilineTextAlignment(.center)
    }
    
    
    private func setupNewTip() -> String {
        let candlesLeft = candles.filter({ !$0.blownOut }).count
        
        switch candlesLeft {
        case 9...10:
            return "Take a deep breath, and blow out the candles!"
        case 7...8:
            return "That’s it!\nKeep Blowing."
        case 4...6:
            return "Keep going until all the candles are out."
        case 1...3:
            return "One last deep breath..."
        case 0:
            return "Well done!"
        default:
            return ""
        }
    }
}

#Preview {
    BlowOutTheCandlesView()
        .environmentObject(NavigationManager())
        .environmentObject(ParentDataManager())
}
