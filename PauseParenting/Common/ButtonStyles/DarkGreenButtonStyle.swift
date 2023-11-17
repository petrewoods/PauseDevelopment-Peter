//
//  DarkGreenButtonStyle.swift
//  PauseParenting
//
//  Created by Peter Woods on 09/11/2023.
//



import SwiftUI

struct DarkGreenButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.poppins600, size: 18)
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .padding(.leading,40)       
            .background (
                ZStack {
                    RoundedRectangle(cornerRadius: 43)
                        .fill(Color.ignore)
                }
            )
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

extension ButtonStyle where Self == DarkGreenButtonStyle {
    static var darkGreenButton: DarkGreenButtonStyle { DarkGreenButtonStyle() }
}

#Preview {
    Button(action: {}) {
        Text("Start Ignore")
    }
    .buttonStyle(.darkGreenButton)
    .padding(.horizontal)
}
