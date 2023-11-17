//
//  MainTextEditorView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 10.10.2023.
//

import SwiftUI

struct MainTextEditorView: View {
    @Binding var text: String
    
    let promptText: String
    let fieldHeight: CGFloat
    
    init(text: Binding<String>, promptText: String, fieldHeight: CGFloat = 100) {
        self._text = text
        self.promptText = promptText
        self.fieldHeight = fieldHeight
    }
    
    var body: some View {
        editor
    }
    
    private var editor: some View {
        TextEditor(text: $text)
            .clearTextfield()
            .autocorrectionDisabled()
            .padding()
            .frame(height: fieldHeight)
            .font(.poppins400, size: 16)
            .foregroundStyle(Color.textDark)
            .overlay(
                overlayPromptText,
                alignment: .topLeading
            )
    }
    
    private var overlayPromptText: some View {
        Text(promptText)
            .foregroundStyle(Color.grayBackground)
            .padding(20)
            .opacity(text.isEmpty ? 1 : 0)
            .allowsHitTesting(false)
    }
}

#Preview {
    MainTextEditorView(text: .constant(""), promptText: "What calms me down?")
}
