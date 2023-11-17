//
//  ProfilesChildCard.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 18.10.2023.
//

import SwiftUI

struct ProfilesChildCard: View {
    let child: ChildModel
    
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                name
                age
            }
            icon
        }
        .padding([.vertical, .trailing], 10)
        .padding(.leading, 18)
    }
    
    private var name: some View {
        Text(child.name)
            .font(.poppins600, size: 24)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var age: some View {
        Text("Age \(child.age)")
            .font(.poppins500, size: 14)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .foregroundStyle(child.color)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var icon: some View {
        PersonImage(
            image: child.image,
            color: child.color,
            size: 62,
            lineWidth: 4
        )
    }
}

#Preview {
    ProfilesChildCard(child: .mockChildAlex)
}
