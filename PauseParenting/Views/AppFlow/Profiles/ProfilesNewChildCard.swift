//
//  ProfilesNewChildCard.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 18.10.2023.
//

import SwiftUI

struct ProfilesNewChildCard: View {
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(spacing: 0) {
                    title
                    description
                }
                icon
            }
            .foregroundStyle(Color.textDark)
            .padding([.vertical, .trailing], 10)
            .padding(.leading, 18)
            .card()
        }
    }
    
    private var title: some View {
        Text("New Child Profile")
            .font(.poppins600, size: 24)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var description: some View {
        Text("Set up a profile for a new child")
            .font(.poppins400, size: 14)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var icon: some View {
        PersonIcon()
    }
}

#Preview {
    ProfilesNewChildCard(action: {})
}
