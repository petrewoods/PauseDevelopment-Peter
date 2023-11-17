//
//  MainDarkBlueButtonStyle.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 09.10.2023.
//

import SwiftUI

struct MainDarkBlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.poppins600, size: 18)
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .center)
            .background (
                ZStack {
                    RoundedRectangle(cornerRadius: 43)
                        .fill(Color.darkBlue)
                }
            )
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

extension ButtonStyle where Self == MainDarkBlueButton {
    static var mainDarkBlueButton: MainDarkBlueButton { MainDarkBlueButton() }
}

#Preview {
    Button(action: {}) {
        Text("Add child profile")
    }
    .buttonStyle(.mainDarkBlueButton)}
