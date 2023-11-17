//
//  AboutAppView.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 01.11.2023.
//

import SwiftUI

struct AboutAppView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        contentView
            .navigationTitle("About the app")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .background(Color.mainYellowBackground)
            .tabbarSafearea()
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("pauseLogo")
                .resizable()
                .frame(width: 210, height: 48)
                .padding(.top, 54)
            textView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 37)
    }
    
    @ViewBuilder
    private var textView: some View {
        let text = "Pause guides parents through evidence-based parenting techniques in moments of crisis, as well as helping parents prepare for difficult times and get back to normal afterwards.\n\nThis interactive app draws on 40 years of parenting research (and includes elements of mindfulness) to help parents use short, consistent, and effective time out, calming time, or quiet time when their children are having difficulty managing their emotions.\n\nWith easy-to-use advice about encouraging children, a mindfulness zone, and three simple timers, “Pause” makes it easier to be a great parent."
        Text(text)
            .font(.poppins400, size: 16)
            .foregroundStyle(Color.textSecondary)
            .padding(.top, 50)
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    AboutAppView()
}
