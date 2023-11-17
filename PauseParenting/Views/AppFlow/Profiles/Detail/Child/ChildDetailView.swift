//
//  ChildDetailView.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 19.10.2023.
//

import SwiftUI

struct ChildDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @State private var isEditImage = false
    @State private var isDeleteProfile = false
    
    @State var child: ChildModel
    
    @State private var childChanged = false
    
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
        .onChange(of: child) { _ in
            childChanged = true
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
                        updateChild()
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
        ChildCard(
            child: $child,
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
    
    private func updateChild() {
        guard childChanged else { return }
        
        Task {
            do {
                try await ChildRepository.updateChild(child)
            } catch {
                print("[Error][ChildDetailView] updateChild: \(error)")
            }
            
            childChanged = false
        }
    }
}

fileprivate struct ChildCard: View {
    @EnvironmentObject private var parentDataManager: ParentDataManager
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var child: ChildModel
    let isEditing: Bool
    @Binding var isEditImage: Bool
    @Binding var isDeleteProfile: Bool
    
    var body: some View {
        VStack {
            if isEditImage {
                EditImageView(
                    image: child.image,
                    personColor: $child.color,
                    onSelect: {
                        child.image = (child.id ?? "") + "_" + UUID().uuidString
                        ImageRepository.saveImage($0, id: child.image)
                    }
                )
            } else {
                if isDeleteProfile {
                    DeleteProfileView(
                        name: child.name,
                        image: child.image,
                        color: child.color,
                        onDelete: deleteAction,
                        isDelete: $isDeleteProfile
                    )
                } else {
                    header
                    details
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .card()
    }
    
    private var header: some View {
        HStack {
            VStack(spacing: 0) {
                Text(child.name)
                    .font(.poppins600, size: 36)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Age \(child.age)")
                    .font(.poppins400, size: 16)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if isEditing {
                PersonImage(image: child.image, color: child.color, size: 130) {
                    withAnimation {
                        isEditImage = true
                    }
                }
            } else {
                PersonImage(image: child.image, color: child.color, size: 130)
            }
        }
        .padding(.trailing, 5)
    }
    
    private var details: some View {
        VStack(spacing: 20) {
            ForEach(ChildDetailType.allCases) { type in
                let detail = getDetailBinding(by: type)
                ChildCardCell(type: type, detail: detail)
            }
            
            if isEditing {
                Button {
                    withAnimation {
                        isDeleteProfile = true
                    }
                } label: {
                    Text("Delete profile")
                        .font(.poppins500, size: 18)
                        .foregroundStyle(Color.deleteAction)
                }
            }
        }
    }
    
    private func getDetailBinding(by type: ChildDetailType) -> Binding<String> {
        return .init(
            get: {
                switch type {
                case .developmentalAge: return child.developmentalAge >= 0 ? child.developmentalAge.description : ""
                case .whatCalmsMeDown: return child.questions.calmsDown
                case .whatAmIGoodAt: return child.questions.goodAt
                case .whatDoIFindHard: return child.questions.findHard
                case .whatDoILoveFromMyParents: return child.questions.loveFromParents
                }
            }, set: {
                switch type {
                case .developmentalAge: 
                    let age = Int($0) ?? -1
                    return child.developmentalAge = age >= 0 ? age : -1
                case .whatCalmsMeDown: return child.questions.calmsDown = $0
                case .whatAmIGoodAt: return child.questions.goodAt = $0
                case .whatDoIFindHard: return child.questions.findHard = $0
                case .whatDoILoveFromMyParents: return child.questions.loveFromParents = $0
                }
            }
        )
    }
    
    private func deleteAction() { Task {
        do {
            try await ChildRepository.deleteChild(child)
            DispatchQueue.main.async { dismiss.callAsFunction() }
        } catch {
            print("[Error][ChildCard] deleteAction: \(error)")
        }
    }}
}

fileprivate struct ChildCardCell: View {
    let type: ChildDetailType
    @Binding var detail: String
    
    @State private var isFocused = false
    
    private var isHorizontal: Bool {
        type == .developmentalAge
    }
    
    var body: some View {
        VStack(spacing: 12) {
            divider
            
            let layout = isHorizontal ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(spacing: 8))
            
            layout {
                title
                description
            }
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
        DetailTextEditor(
            placeholder: type == .developmentalAge ? "Age" : type.title,
            text: $detail,
            isFocused: $isFocused
        )
        .frame(
            maxWidth: isHorizontal ? 40 : .infinity,
            alignment: .leading
        )
    }
}

#Preview {
    ChildDetailView(child: .mockChildAlex)
        .environmentObject(NavigationManager())
}
