//
//  DarkGrayButtonStyle.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 24.10.2023.
//

import SwiftUI

struct DarkGrayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.textDark)
            .font(.poppins600, size: 18)
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .center)
            .background (
                ZStack {
                    RoundedRectangle(cornerRadius: 43)
                        .fill(Color.buttonBackground)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                }
            )
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

extension ButtonStyle where Self == DarkGrayButtonStyle {
    static var darkGrayButton: DarkGrayButtonStyle { DarkGrayButtonStyle() }
}

#Preview {
    Button(action: {}) {
        Text("Done")
    }
    .buttonStyle(.darkGrayButton)
    .padding(.horizontal)
}
