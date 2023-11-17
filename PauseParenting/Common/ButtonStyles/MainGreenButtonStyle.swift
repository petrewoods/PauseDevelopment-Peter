//
//  MainGreenButtonStyle.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 06.10.2023.
//

import SwiftUI

struct MainGreenButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.poppins600, size: 18)
            .frame(minHeight: 60, alignment: .center)
            .background (
                ZStack {
                    RoundedRectangle(cornerRadius: 43)
                        .fill(Color.greenSuccess)
                }
            )
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

extension ButtonStyle where Self == MainGreenButton {
    static var mainGreenButton: MainGreenButton { MainGreenButton() }
}

#Preview {
    Button(action: {}) {
        Text("Next")
            .frame(maxWidth: .infinity)
    }
    .buttonStyle(.mainGreenButton)
}
