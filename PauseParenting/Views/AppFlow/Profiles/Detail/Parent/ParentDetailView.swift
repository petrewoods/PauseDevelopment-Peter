//
//  ParentDetailView.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 27.10.2023.
//

import SwiftUI

struct ParentDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @State private var isEditImage = false
    @State private var isDeleteProfile = false
    
    @State var parent: UserModel
    
    @State private var userUpdated = false
    
    var body: some View {
        VStack(spacing: 8) {
            header
            ScrollView {
                childCard
            }
            .scrollDismissesKeyboard(.interactively)
            .tabbarSafearea()
        }
        .background(background)
        .onChange(of: parent) { _ in
            userUpdated = true
        }
    }
    
    private var header: some View {
        HStack {
            Button(action: dismiss.callAsFunction) {
                HStack(spacing: 10) {
                    Image("leftArrowIcon")
                        .renderingMode(.template)
                    
                    Text("Profiles")
                        .font(.poppins500, size: 18)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
                .contentShape(Rectangle())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(isEditing ? 0 : 1)
            
            if !isDeleteProfile {
                Button { withAnimation {
                    isEditing.toggle()
                    isEditImage = false
                    UIApplication.shared.endEditing()
                    
                    if !isEditing {
                        updateUser()
                    }
                }} label: {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.poppins500, size: 18)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
            }
        }
        .foregroundStyle(Color.blueAction)
        .padding(.horizontal, 32)
        .padding(.top, 38)
    }
    
    private var childCard: some View {
        ParentCard(
            parent: $parent,
            isEditing: isEditing,
            isEditImage: $isEditImage,
            isDeleteProfile: $isDeleteProfile
        )
        .padding(.horizontal, 19)
        .padding(.vertical, 28)
        .disabled(!isEditing)
    }
    
    @ViewBuilder
    private var background: some View {
        if isEditing {
            Color.secondaryTextGray.ignoresSafeArea()
        } else {
            Color.mainYellowBackground.ignoresSafeArea()
        }
    }
    
    private func updateUser() {
        guard userUpdated else { return }
        
        Task {
            do {
                try await UserRepository.updateUser(parent)
            } catch {
                print("[Error][ParentDetailView] update user: \(error)")
            }
            
            userUpdated = false
        }
    }
}

fileprivate struct ParentCard: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var parentDataManager: ParentDataManager
    
    @Binding var parent: UserModel
    let isEditing: Bool
    @Binding var isEditImage: Bool
    @Binding var isDeleteProfile: Bool
    
    var body: some View {
        VStack {
            if isEditImage {
                EditImageView(
                    image: parent.image,
                    personColor: $parent.color,
                    onSelect: {
                        parent.image = (parent.id ?? "") + "_" + UUID().uuidString
                        ImageRepository.saveImage($0, id: parent.image)
                    }
                )
            } else {
                if isDeleteProfile {
                    DeleteProfileView(
                        name: parent.name,
                        image: parent.image,
                        color: parent.color,
                        onDelete: deleteAction,
                        isDelete: $isDeleteProfile
                    )
                } else {
                    header
                    details
                    bottomButton
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .card()
    }
    
    private var header: some View {
        HStack {
            Text(parent.name)
                .font(.poppins600, size: 36)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if isEditing {
                PersonImage(image: parent.image, color: parent.color, size: 130) {
                    withAnimation {
                        isEditImage = true
                    }
                }
            } else {
                PersonImage(image: parent.image, color: parent.color, size: 130)
            }
        }
        .padding(.trailing, 5)
    }
    
    private var details: some View {
        VStack(spacing: 20) {
            ForEach(ParentDetailType.allCases) { type in
                let detail = getDetailBinding(by: type)
                ParentCardCell(type: type, detail: detail)
            }
        }
    }
    
    private var bottomButton: some View {
        Button {
            withAnimation {
                isDeleteProfile = true
            }
        } label: {
            Text(isEditing ? "Delete profile" : "Switch to active profile")
                .font(.poppins500, size: 18)
                .foregroundStyle(isEditing ? Color.deleteAction : .green)
        }
        .padding(.top, 118)
    }
    
    private func getDetailBinding(by type: ParentDetailType) -> Binding<String> {
        return .init(
            get: {
                switch type {
                case .whatIdoToRelax: return parent.questions.relax
                case .whatMakesMeStressed: return parent.questions.stressed
                }
            },
            set: {
                switch type {
                case .whatIdoToRelax: parent.questions.relax = $0
                case .whatMakesMeStressed: parent.questions.stressed = $0
                }
            }
        )
    }
    
    private func deleteAction() { Task {
        do {
            try await UserRepository.deleteUser(parent)
            try await AuthManager.logout()
            navigationManager.logout()
        } catch {
            print("[Error][ParentCard] deleteAction: \(error)")
        }
    }}
}

fileprivate struct ParentCardCell: View {
    let type: ParentDetailType
    @Binding var detail: String
    
    @State private var isFocused = false
    
    var body: some View {
        VStack(spacing: 12) {
            divider
            title
            description
        }
    }
    
    private var divider: some View {
        Divider()
    }
    
    private var title: some View {
        Text(type.title)
            .font(.poppins400, size: 16)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var description: some View {
        DetailTextEditor(placeholder: type.title, text: $detail, isFocused: $isFocused)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ParentDetailView(parent: UserModel.mock)
        .environmentObject(NavigationManager())
}
