//
//  StartSessionButtonView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 23.10.2023.
//

import SwiftUI

struct StartSessionButton: ButtonStyle {
    @Binding var isButtonPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Circle()
                    .frame(width: isButtonPressed ? 84 : 100, height: isButtonPressed ? 84 : 100)
                    .foregroundStyle(isButtonPressed ? Color.blindRelaxButton : Color.secondaryTextGray)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
            )
            .background(
                Circle()
                    .frame(width: 140, height: 140)
                    .foregroundStyle(Color.buttonBackground.opacity(0.5))
            )
        
    }
}

#Preview {
    Button {
        
    } label: {
        Image("relaxTogetherIcon")
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.white)
            .frame(width: 52, height: 37)
    }
    .buttonStyle(StartSessionButton(isButtonPressed: .constant(false)))
}
