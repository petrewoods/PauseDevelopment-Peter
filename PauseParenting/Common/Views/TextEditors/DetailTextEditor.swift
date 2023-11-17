//
//  DetailTextEditor.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 19.10.2023.
//

import SwiftUI

struct DetailTextEditor: View {
    public let placeholder: String
    
    @Binding public var text: String
    @Binding public var isFocused: Bool
    
    var body: some View {
        MultilineTextField(
            text: $text,
            isFocused: $isFocused,
            placeholder: placeholder
        )
    }
}

fileprivate struct MultilineTextField: View {
    @Binding public var text: String
    @Binding public var isFocused: Bool
    
    public var placeholder: String
    public var onCommit: (() -> Void)?
    
    @State private var dynamicHeight: CGFloat = 100
    
    var body: some View {
        UITextViewWrapper(
            text: $text,
            calculatedHeight: $dynamicHeight,
            isFirstResponder: $isFocused,
            onDone: onCommit
        )
        .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
        .overlay(placeholderView, alignment: .topLeading)
        .padding(.leading, -5)
    }
    
    @ViewBuilder
    var placeholderView: some View {
        if text.isEmpty {
            Text(placeholder)
                .font(.poppins400, size: 16)
                .foregroundColor(.textSecondary)
                .padding(.leading, 5)
                .allowsHitTesting(false)
        }
    }
}

#Preview {
    DetailTextEditor(
        placeholder: "What Calms Me Down?",
        text: .constant(""),
        isFocused: .constant(true)
    )
}

fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    @Binding var isFirstResponder: Bool
    var onDone: (() -> Void)?
    
    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator
        
        textField.isEditable = true
        textField.font = CustomFont.poppins400.uiFont(16)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIColor(.textSecondary)
        textField.textContainerInset = .zero
        
        if nil != onDone {
            textField.returnKeyType = .done
        }
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != text {
            uiView.text = text
        }
        
        DispatchQueue.main.async {
            if isFirstResponder {
                uiView.becomeFirstResponder()
            } else {
                uiView.resignFirstResponder()
            }
        }
        
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
        uiView.isScrollEnabled = calculatedHeight == ScreenUtils.height * 0.18
    }
    
    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                if newSize.height > ScreenUtils.height * 0.18 {
                    result.wrappedValue = ScreenUtils.height * 0.18
                } else {
                    result.wrappedValue = newSize.height
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone, isFirstResponder: $isFirstResponder)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        var isFirstResponder: Binding<Bool>
        
        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
            self.isFirstResponder = isFirstResponder
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }
        
        func textViewDidEndEditing(_ uiView: UITextView) {
            isFirstResponder.wrappedValue = false
        }
        
        func textViewDidBeginEditing(_ uiView: UITextView) {
            isFirstResponder.wrappedValue = true
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }
    
}



