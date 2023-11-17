//
//  ProfilesParentCellView.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 18.10.2023.
//

import SwiftUI

struct ProfilesParentCellView: View, Equatable {
    static func == (lhs: ProfilesParentCellView, rhs: ProfilesParentCellView) -> Bool {
        lhs.parent == rhs.parent
    }
    
    let parent: UserModel?
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Group {
                if let parent, parent.isRegistered {
                    ParentCell(parent: parent)
                } else {
                    SetupParent()
                }
            }
            .padding([.vertical, .trailing], 10)
            .padding(.leading, 18)
            .card(backgroundColor: parent == nil ? .grayBackground : .white)
        }
        .foregroundStyle(Color.textDark)
    }
}

fileprivate struct ParentCell: View, Equatable {
    let parent: UserModel
    
    var body: some View {
        HStack {
            name
            icon
        }
    }
    
    private var name: some View {
        Text(parent.name)
            .font(.poppins600, size: 24)
            .lineLimit(2)
            .minimumScaleFactor(0.1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var icon: some View {
        PersonImage(
            image: parent.image,
            color: parent.color,
            size: 62,
            lineWidth: 4
        )
    }
}

fileprivate struct SetupParent: View, Equatable {
    var body: some View {
        HStack {
            VStack(spacing: 4) {
                title
                description
            }
            icon
        }
    }
    
    private var title: some View {
        Text("Set Up Parent Profile")
            .font(.poppins400, size: 20)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var description: some View {
        Text("Add details to your Parent Profile")
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
    VStack {
        ProfilesParentCellView(parent: .mock, action: { })
        ProfilesParentCellView(parent: nil, action: { })
    }
}
