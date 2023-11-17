//
//  ExtentedTextEditorView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 10.10.2023.
//

import SwiftUI

struct ExtentedTextEditorView: View {
    @Binding var text: String
    
    let mainPromptText: String
    let secondaryPromptText: String
    
    var body: some View {
        editor
    }
    
    private var editor: some View {
        TextEditor(text: $text)
            .clearTextfield()
            .autocorrectionDisabled()
            .padding()
            .frame(height: 150)
            .font(.poppins400, size: 16)
            .foregroundStyle(Color.textDark)
            .overlay(
                overlayPromptText,
                alignment: .topLeading
            )
    }
    
    private var overlayPromptText: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(mainPromptText)
                .font(.poppins400, size: 16)
            Text(secondaryPromptText)
                .font(.poppins400, size: 14)
        }
        .fixedSize(horizontal: false, vertical: true)
        .foregroundStyle(Color.grayBackground)
        .padding(20)
        .opacity(text.isEmpty ? 1 : 0)
        .allowsHitTesting(false)
    }
}

#Preview {
    ExtentedTextEditorView(text: .constant(""), mainPromptText: "sldkfj", secondaryPromptText: "fjdlfk")
}
