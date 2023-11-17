//
//  NewChildProfileView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 09.10.2023.
//

import SwiftUI

enum SourceType {
    case camera
    case photoLibrary
}

struct NewChildProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var isOnboarding: Bool = true
    let onCreate: (ChildModel, UIImage?) -> ()
    
    @State private var child = ChildModel()
    
    @State private var image: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @State private var sourceType: SourceType = .camera
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    if image != nil {
                        selectedImageView
                    }
                    VStack(spacing: 0) {
                        if image == nil {
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
                        
                        requiredFields
                            .padding(.top, 30)
                        optionalFields
                            .padding(.top, 40)
                        whatDoILoveField
                            .padding(.top, 22)
                        learningDisabilityGroup
                            .padding(.vertical, 22)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 24)
            }
            .scrollIndicators(.hidden)
            .background(
                background,
                alignment: .top
            )
            .imagePicker(isPresented: $isImagePickerPresented) { returnedImage in
                image = returnedImage
            }
            .interactiveDismissDisabled(isOnboarding)
            if isImagePickerPresented {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isImagePickerPresented = false
                    }
            }
        }
    }
    
    private var background: some View {
        Image("secondaryLargeBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
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
                    color: child.color,
                    size: 130,
                    newSelectedImage: unwrapedImg,
                    lineWidth: 4
                )
                .overlay(alignment: .topTrailing) {
                    CustomColorPickerView(colorValue: $child.color)
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
    
    @ViewBuilder
    private var cancelButton: some View {
        if !isOnboarding {
            Button("Cancel") {
                dismiss.callAsFunction()
            }
            .font(.poppins400, size: 16)
            .foregroundStyle(Color.blueAction)
        }
    }
    
    private var doneButton: some View {
        Button("Done") {
            dismiss.callAsFunction()
            onCreate(child, image)
            navigationManager.onboardingStep = .addParent
        }
        .font(.poppins500, size: 18)
        .foregroundStyle(Color.greenSuccess)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .disabled(child.name.isEmpty || child.age < 0)
        .opacity(child.name.isEmpty || child.age < 0 ? 0.3 : 1)
    }
    
    private var title: some View {
        Text("New Child \nProfile")
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
        
    private var requiredFields: some View {
        VStack(spacing: 10) {
            requiredFieldsText
                .padding(.leading)
            
            VStack(spacing: 0) {
                TextField(text: $child.name) {
                    Text("Name")
                        .foregroundStyle(isOnboarding ? Color.blueAction : Color.grayBackground)
                        .font(.poppins400, size: 16)
                }
                .frame(height: 50)
                .padding(.horizontal)
                .clearTextfield()
                
                Divider()
                
                TextField(text: $child.age.stringBinding) {
                    Text("Age")
                        .foregroundStyle(isOnboarding ? Color.blueAction : Color.grayBackground)
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
    }
    
    @ViewBuilder
    private var requiredFieldsText: some View {
        if isOnboarding {
            Text("Required Fields")
                .font(.poppins400, size: 14)
                .foregroundStyle(Color.blueAction)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
        
    private var optionalFields: some View {
        VStack(spacing: 10) {
            optionalText
                .padding(.leading)
            
            VStack(spacing: 0) {
                MainTextEditorView(text: $child.questions.calmsDown, promptText: "What calms me down?")
                Divider()
                MainTextEditorView(text: $child.questions.goodAt, promptText: "What am I good at?")
                Divider()
                MainTextEditorView(text: $child.questions.findHard, promptText: "What do I find hard?")
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.white)
            )
        }
    }
    
    @ViewBuilder
    private var optionalText: some View {
        if isOnboarding {
            Text("Optional")
                .font(.poppins400, size: 14)
                .foregroundStyle(Color.textDark)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var whatDoILoveField: some View {
        ExtentedTextEditorView(
            text: $child.questions.loveFromParents,
            mainPromptText: "What do I love from my parents?",
            secondaryPromptText: "e.g. hugs, stories, telling them things, playing together, them watching me play, singing a song, doing sport together, getting dressed up nicely, telling jokes, watching tv together"
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.white)
        )
    }
    
    private var learningDisabilityGroup: some View {
        HStack {
            Text("I have a learning disability or neurodevelopment problems")
                .font(.poppins400, size: 16)
            
            Spacer()
            
            VStack {
                Toggle(isOn: $child.learningDisability, label: {
                    EmptyView()
                })
                .labelsHidden()
                
                Text(child.learningDisability ? "Yes" : "No")
                    .font(.poppins400, size: 14)
            }
        }
        .foregroundStyle(Color.grayBackground)
        .padding(.horizontal)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.white)
        )
    }
}

#Preview {
    NewChildProfileView(onCreate: { _, _ in })
        .environmentObject(NavigationManager())
}
