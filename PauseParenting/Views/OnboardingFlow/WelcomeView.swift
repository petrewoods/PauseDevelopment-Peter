//
//  WelcomeView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 06.10.2023.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var authManager: AuthManager
    
    @State private var showLogo = true
    @State private var shrinkLogo = false
    @State private var applyBottomPadding = true
    @State private var presentNewChildView = false
    @State private var presentNewParentView = false
    
    @FocusState private var isFieldFocused
    
    var body: some View {
        ZStack(alignment: .bottom) {
            background
            VStack(spacing: 0) {
                if showLogo {
                    pauseLogo
                        .padding(.bottom, ScreenUtils.isSmallDisplay ? -80 : 0)
                        .transition(.move(edge: .top))
                }
                
                Group {
                    ZStack {
                        titleSheetContent
                    }
                    .background(
                        whiteEllispse,
                        alignment: .top
                    )
                    ZStack {
                        mainSheetContent
                            .padding(.bottom, isFieldFocused ? 56 : 0)
                    }
                    .background(
                        yellowEllipse,
                        alignment: .top
                    )
                }
                .offset(y: applyBottomPadding ? 500 : 0)
                .frame(height: applyBottomPadding ? 0 : nil)
            }
            .padding(.bottom, ScreenUtils.isSmallDisplay ? 80 : 0)
        }
        .onAppear {
            withAnimation(.spring(duration: 1.0)) {
                applyBottomPadding = false
                shrinkLogo = true
            }
        }
        .onChange(of: navigationManager.onboardingStep) { newStep in
            if newStep == .completed {
                withAnimation {
                    self.showLogo = false
                    self.applyBottomPadding = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    navigationManager.appState = .authorized
                }
            }
        }
        .sheet(isPresented: $presentNewChildView) {
            NewChildProfileView(onCreate: authManager.handleChildCreation)
        }
        .sheet(isPresented: $presentNewParentView) {
            NewParentProfileView(onCreate: authManager.handleUserCreation)
        }
        .addHideKeyboardButton()
    }
    
    private var background: some View {
        Image("mainBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var pauseLogo: some View {
        Image("pauseLogo")
            .resizable()
            .scaledToFit()
            .frame(width: shrinkLogo ? 172 : 295, height: shrinkLogo ? 43 : 68)
            .frame(maxHeight: .infinity)
    }
    
    private var whiteEllispse: some View {
        Ellipse()
            .foregroundColor(.white)
            .frame(width: 1357, height: 563)
            .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: -5)
            .frame(width: UIScreen.main.bounds.width)
    }
    
    private var yellowEllipse: some View {
        Ellipse()
            .foregroundColor(.mainYellowBackground)
            .frame(width: 1209, height: 563)
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: UIScreen.main.bounds.width)
    }
    
    private var titleSheetContent: some View {
        Group {
            switch navigationManager.onboardingStep {
            case .welcome:
                welcomeText
            case .addChild, .addParent, .completed:
                profileIcon
            }
        }
        .padding(.vertical, 50)
        .padding(.horizontal, 32)
    }
    
    private var mainSheetContent: some View {
        Group {
            switch navigationManager.onboardingStep {
            case .welcome:
                VStack(spacing: 25) {
                    enterPostcodeText
                    postcodeField
                    if authManager.isVerified {
                        nextButton
                            .padding(.top, 20)
                    } else {
                        skipButton
                            .padding(.top, 20)
                    }
                }
                .padding(.top, 46)
            case .addChild:
                VStack(spacing: 64) {
                    addProfileText
                    addChildButton
                }
                .padding(.top, 98)
            case .addParent, .completed:
                VStack(spacing: 27) {
                    addParentText
                    addParentProfileButton
                    parentSkipButton
                }
                .padding(.top, 48)
            }
        }
        .padding(.bottom, 46)
        .padding(.horizontal, 32)
    }
    
    private var welcomeText: some View {
        Text("Welcome")
            .foregroundColor(.textDark)
            .font(.poppins700, size: 48)
    }
    
    private var enterPostcodeText: some View {
        Text("Enter your postcode to get started.")
            .foregroundColor(.black)
            .font(.poppins500, size: 16)
    }
    
    private var postcodeField: some View {
        HStack {
            Text("Postcode")
                .font(.body)
                .fontWeight(.regular)
                .foregroundColor(Color.black)
            
            TextField("", text: $authManager.postcode, onEditingChanged: { isEditing in
                if isEditing { return }
                authManager.verifyPostcode()
            })
            .keyboardType(.alphabet)
            .foregroundColor(.textSecondary)
            .overlay(alignment: .trailing) {
                if authManager.isLoading {
                    ProgressView()
                        .frame(width: 32, height: 32)
                }
            }
            .focused($isFieldFocused)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
        }
        .padding(.vertical, 11)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
        )
        .onTapGesture {
            withAnimation {
                isFieldFocused = true
            }
        }
    }
    
    private var skipButton: some View {
        Button {
            withAnimation(.spring(duration: 0.6)) {
                navigationManager.onboardingStep = .addChild
            }
        } label: {
            Text("Skip")
        }
        .buttonStyle(.grayButton)
        .disabled(true)
    }
    
    private var nextButton: some View {
        Button {
            withAnimation(.spring(duration: 0.6)) {
                navigationManager.onboardingStep = .addChild
                authManager.postcode = ""
            }
        } label: {
            Text("Next")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.mainGreenButton)
    }
    
    private var profileIcon: some View {
        Image("profileIcon")
            .frame(width: 110, height: 110)
            .background(
                RoundedRectangle(cornerRadius: 27)
                    .foregroundColor(.darkBlue)
            )
    }
    
    private var addProfileText: some View {
        Text("To get started, add your first child profile now.")
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(.black)
            .font(.poppins500, size: 16)
    }
    
    private var addChildButton: some View {
        Button {
            presentNewChildView = true
        } label: {
            Text("Add child profile")
        }
        .buttonStyle(.mainDarkBlueButton)
    }
    
    private var addParentText: some View {
        Text("For the best experience we recommend also setting up your parent profile now.")
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(.black)
            .font(.poppins500, size: 16)
    }
    
    private var addParentProfileButton: some View {
        Button {
            presentNewParentView = true
        } label: {
            Text("Add your parent profile")
        }
        .buttonStyle(.mainDarkBlueButton)
    }
    
    private var parentSkipButton: some View {
        Button {
            navigationManager.onboardingStep = .completed
        } label: {
            Text("Skip")
                .foregroundStyle(Color.textDark)
        }
        .buttonStyle(.grayButton)
    }
}

#Preview {
    WelcomeView()
        .environmentObject(NavigationManager())
}
