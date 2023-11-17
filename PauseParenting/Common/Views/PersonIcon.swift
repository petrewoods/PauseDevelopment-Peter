//
//  PersonIcon.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 18.10.2023.
//

import SwiftUI

struct PersonIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blueAction)
            
            Image("profilesIcon")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundStyle(.white)
        }
        .frame(width: 62, height: 62)
    }
}

#Preview {
    PersonIcon()
}
