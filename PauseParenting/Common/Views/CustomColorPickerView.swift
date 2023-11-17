//
//  CustomColorPickerView.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 26.10.2023.
//

import SwiftUI

struct CustomColorPickerView: View {
    @Binding var colorValue: Color
    
    var body: some View {
        colorValue
            .frame(width: 36, height: 36, alignment: .topTrailing)
            .cornerRadius(25.0)
            .overlay(
                ZStack {
                    AngularGradient(gradient:
                                        Gradient(colors: [.red,.purple, .blue, .white, .green, .yellow]), center:.center)
                    .cornerRadius(50.0)
                    ColorPicker("", selection: $colorValue)
                        .labelsHidden()
                        .opacity(0.015)
                }
            )
    }
}
