//
//  GrayButtonStyle.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 06.10.2023.
//

import SwiftUI

struct GrayButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.textSecondary)
            .font(.poppins600, size: 18)
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .center)
            .background (
                ZStack {
                    RoundedRectangle(cornerRadius: 43)
                        .fill(Color.grayBackground)
                }
            )
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

extension ButtonStyle where Self == GrayButton {
    static var grayButton: GrayButton { GrayButton() }
}

#Preview {
    Button(action: {}) {
        Text("Skip")
    }
    .buttonStyle(.grayButton)
}
