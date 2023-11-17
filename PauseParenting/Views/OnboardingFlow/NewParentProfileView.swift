//
//  NewParentProfileView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 11.10.2023.
//

import SwiftUI

enum UsingPauseGoal: CaseIterable {
    case improveChildsBehaviour
    case improveRelationship
    case learnTimeOut
    case helpRelax
    
    var title: String {
        switch self {
        case .improveChildsBehaviour: "To improve my Childs behaviour"
        case .improveRelationship: "To improve my relationship with my Child"
        case .learnTimeOut: "To learn how to do time out"
        case .helpRelax: "To help me and my child to relax"
        }
    }
}

struct NewParentProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var navigationManager: NavigationManager
    
    public var isOnboarding: Bool = true
    public let onCreate: (UserModel, UIImage?) -> ()
    
    @State private var image: UIImage?
    @State private var parent = UserModel()
    @State private var showUsePauseSheet = false
    @State private var isImagePickerPresented = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if image != nil {
                    selectedImageView
                } else {
                    HStack {
                        cancelButton
                        doneButton
                    }
                }
                HStack {
                    title
                    Spacer()
                    if image == nil {
                        imagePlaceholderAndText
                    }
                }
                .padding(.top, 18)
                
                VStack(spacing: 22) {
                    mainFields
                    ageField
                    mainEditors
                    howUsePause
                }
                .padding(.top, 30)
                
                completeButton
                    .padding(.top, 200)
            }
            .padding(.horizontal)
            .padding(.top, 24)
        }
        .scrollIndicators(.hidden)
        .background(
            background,
            alignment: .top
        )
        .sheet(isPresented: $showUsePauseSheet) {
            usingPauseSheet
                .presentationDetents([.height(400)])
                .presentationBackground(.clear)
        }
        .imagePicker(isPresented: $isImagePickerPresented) { returnedImage in
            image = returnedImage
        }
    }
    
    private var background: some View {
        Image("secondaryLargeBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var doneButton: some View {
        Button(action: doneAction) {
            Text("Done")
                .font(.poppins500, size: 18)
                .foregroundStyle(Color.greenSuccess)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var cancelButton: some View {
        Button {
            dismiss.callAsFunction()
        } label: {
            Text("Cancel")
                .font(.poppins400, size: 16)
                .foregroundStyle(Color.blueAction)
        }
    }
    
    private var title: some View {
        Text("New Parent Profile")
            .font(.poppins700, size: 40)
            .foregroundStyle(Color.textDark)
    }
    
    @ViewBuilder
    private var imagePlaceholderAndText: some View {
        VStack(spacing: 13) {
            Image("profileIcon")
                .resizable()
                .scaledToFill()
                .frame(width: 29, height: 32)
                .frame(width: 62, height: 62)
                .background(Color.blueAction)
                .clipShape(Circle())
            
            Text("ADD PHOTO")
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
        }
        .onTapGesture {
            isImagePickerPresented = true
        }
    }
    
    @ViewBuilder
    private var selectedImageView: some View {
        if let unwrapedImg = image {
            VStack(spacing: 16) {
                HStack {
                    cancelButton
                    Spacer()
                    doneButton
                }
                PersonImage(
                    image: "",
                    color: parent.color,
                    size: 130,
                    newSelectedImage: unwrapedImg,
                    lineWidth: 4
                )
                .overlay(alignment: .topTrailing) {
                    CustomColorPickerView(colorValue: $parent.color)
                }
                Text("Chose another photo")
                    .font(.poppins500, size: 18)
                    .foregroundStyle(Color.blueAction)
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            }
            .padding(.bottom, 50)
        }
    }
    
    private var mainFields: some View {
        VStack(spacing: 0) {
            TextField(text: $parent.firstName) {
                Text("First Name")
                    .foregroundStyle(Color.grayBackground)
                    .font(.poppins400, size: 16)
            }
            .frame(height: 50)
            .padding(.horizontal)
            .clearTextfield()
            
            Divider()
            
            TextField(text: $parent.lastName) {
                Text("Last Name")
                    .foregroundStyle(Color.grayBackground)
                    .font(.poppins400, size: 16)
            }
            .frame(height: 50)
            .padding(.horizontal)
            .clearTextfield()
        }
        .foregroundStyle(Color.textDark)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.white)
        )
    }
    
    private var ageField: some View {
        TextField(text: $parent.age.stringBinding) {
            Text("Age")
                .foregroundStyle(Color.grayBackground)
                .font(.poppins400, size: 16)
        }
        .frame(height: 50)
        .padding(.horizontal)
        .clearTextfield()
        .foregroundStyle(Color.textDark)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.white)
        )
    }
    
    private var mainEditors: some View {
        VStack(spacing: 0) {
            MainTextEditorView(text: $parent.questions.relax, promptText: "What I do to relax?")
            Divider()
            MainTextEditorView(text: $parent.questions.stressed, promptText: "What makes me stressed?")
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.white)
        )
    }
    
    private var howUsePause: some View {
        Button {
            showUsePauseSheet = true
        } label: {
            HStack {
                Text("How will you use Pause?")
                    .font(.poppins400, size: 16)
                Spacer()
                Image(systemName: "chevron.right")
                    .bold()
            }
            .foregroundStyle(Color.blueAction)
            .padding(.horizontal)
        }
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.white)
        )
    }
    
    private var usingPauseSheet: some View {
        VStack(spacing: 30) {
            Text("Please Select")
                .font(.poppins400, size: 20)
                .foregroundStyle(Color.mainTextGray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 24) {
                ForEach(UsingPauseGoal.allCases, id: \.self) { goal in
                    Button {
                        parent.questions.goals = goal.title
                        showUsePauseSheet = false
                    } label: {
                        Text(goal.title)
                            .font(.poppins400, size: 16)
                            .foregroundStyle(Color.secondaryTextGray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .padding(.top, 40)
        .frame(height: 400)
        .background(
            RoundedRectangle(cornerRadius: 36)
                .foregroundStyle(Color.white)
        )
        .padding(.bottom, -100)
    }
    
    private var completeButton: some View {
        Button(action: doneAction) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 62, height: 62)
                .foregroundStyle(Color.greenSuccess)
        }
    }
    
    private func doneAction() {
        parent.isRegistered = true
        onCreate(parent, image)
        
        dismiss.callAsFunction()
        
        if isOnboarding {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                navigationManager.onboardingStep = .completed
            }
        }
    }
}

#Preview {
    NewParentProfileView(onCreate: { _, _ in })
        .environmentObject(NavigationManager())
}
