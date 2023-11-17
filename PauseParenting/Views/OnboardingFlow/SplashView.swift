//
//  SplashView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 06.10.2023.
//

import SwiftUI

struct SplashView: View {
    @State private var isLogoVisible = false
    @State private var isBackgroundVisible = false
    
    var body: some View {
        ZStack {
            background
            pauseLogo
        }
        .onAppear {
            elementsVisibility()
        }
    }
    
    private var background: some View {
        Image("mainBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .opacity(isBackgroundVisible ? 1 : 0)
    }
    
    private var pauseLogo: some View {
        Image("pauseLogo")
            .opacity(isLogoVisible ? 1 : 0)
    }
    
    
    //MARK: Methods
    
    private func elementsVisibility() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(duration: 2.0)) {
                self.isLogoVisible = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.spring(duration: 2.0)) {
                self.isBackgroundVisible = true
            }
        }
    }
}

#Preview {
    SplashView()
}
