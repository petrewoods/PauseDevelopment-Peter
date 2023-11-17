//
//  DeleteProfileView.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 27.10.2023.
//

import SwiftUI

struct DeleteProfileView: View {
    let name: String
    let image: String
    let color: Color
    let onDelete: () -> ()
    @Binding var isDelete: Bool
    @State private var isSureSwitchedOn = false
    
    var body: some View {
        VStack(spacing: 0) {
            PersonImage(image: image, color: color, size: 130)
                .padding(.top, 56)
            title
            if isSureSwitchedOn {
                deleteButton
            } else {
                description
            }
            sureSection
            cancelButton
        }
        .frame(maxWidth: .infinity)
    }
    
    private var title: some View {
        Text(isSureSwitchedOn ? "\(name)" : "Delete Profile")
            .font(.poppins500, size: 36)
            .foregroundStyle(Color.textDark)
            .padding(.top, 24)
    }
    
    private var description: some View {
        VStack {
            Text("Are you sure you want to delete \nthe profile ")
                .font(.poppins300, size: 16)
            +
            Text("\(name)")
                .font(.poppins600, size: 16)
            +
            Text("? This action is \npermanent and can not be \nreversed.")
                .font(.poppins300, size: 16)
        }
        .foregroundStyle(Color.textSecondary)
        .multilineTextAlignment(.center)
        .padding(.top, 17)
    }
    
    private var sureSection: some View {
        VStack {
            Toggle("I understand", isOn: $isSureSwitchedOn)
                .toggleStyle(RedToggleStyle())
        }
        .padding(.top, 64)
    }
    
    private var cancelButton: some View {
        Button {
            withAnimation {
                isDelete = false
            }
        } label: {
            Text("Cancel")
                .font(.poppins400, size: 16)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 43)
                        .fill(Color.profiles)
                        .frame(height: 60)
                )
        }
        .padding(.top, 53)
        .padding(.bottom, 11)
    }
    
    private var deleteButton: some View {
        Button {
            onDelete()
            withAnimation {
                isDelete = false
            }
        } label: {
            Text("Delete Profile")
                .font(.poppins600, size: 16)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 43)
                        .fill(Color.deleteAction)
                        .frame(height: 60)
                )
        }
        .padding(.top, 60)
        .padding(.horizontal, 58)
        .padding(.vertical)
    }
}

#Preview {
    DeleteProfileView(
        name: ChildModel.mockChildKyle.name,
        image: ChildModel.mockChildKyle.image,
        color: ChildModel.mockChildKyle.color, 
        onDelete: {},
        isDelete: .constant(true))
}
