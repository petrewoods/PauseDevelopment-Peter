//
//  RedToggleStyle.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 27.10.2023.
//

import SwiftUI

struct RedToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            Spacer()
            configuration.label
                .font(.poppins300, size: 16)
                .foregroundColor(Color.textDark)
                .padding(.leading, 50)
            Spacer()
            Toggle("", isOn: configuration.$isOn)
                .labelsHidden()
                .padding(.trailing, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 43)
                .fill(Color.sureAlertColor)
                .frame(height: 60)
        )
    }
}
