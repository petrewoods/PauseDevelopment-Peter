//
//  BlowOutTheCandlesInfoAlert.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 31.10.2023.
//

import SwiftUI

struct BlowOutTheCandlesInfoAlertView: View {
    @Binding public var alertType: AlertType?
    
    var body: some View {
        ZStack {
            actualText
                .padding(.horizontal, 40)
                .padding(.vertical, 90)
        }
        .background(
            RoundedRectangle(cornerRadius: 27)
                .foregroundStyle(.white)
        )
        .overlay(
            doneButton,
            alignment: .topTrailing
        )
    }
    
    private var actualText: some View {
        VStack(spacing: 20) {
            Text("This activity uses your phone’s microphone to detect when your child is blowing.")
            Text("Tell them to blow against your phone to put out the candles")
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(.black)
        .font(.poppins400, size: 16)
    }
    
    private var doneButton: some View {
        Button {
            alertType = nil
        } label: {
            Text("Done")
                .font(.poppins500, size: 18)
        }
        .padding(20)
    }
}

#Preview {
    BlowOutTheCandlesInfoAlertView(alertType: .constant(.blowOutTheCandlesInfo))
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.opacity(0.4))
        
}
