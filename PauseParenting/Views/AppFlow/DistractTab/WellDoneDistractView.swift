//
//  WellDoneDistractView.swift
//  PauseParenting
//
//  Created by Peter Woods on 04/11/2023.
//


import SwiftUI

struct WellDoneDistractView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var parentData: ParentDataManager
        
    @State private var showAddNewEntrySheet = false
        
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                doneButton
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                distractImage
                    .padding(.top, 42)
                
                HStack(spacing: 10) {
                    wellDoneText
                    sendButton
                }
                .padding(.trailing, -20)
                .padding(.top, 20)
                
                infoText
                    .padding(.top, 8)
                
                VStack(spacing: 36) {
                    addJournalButton
                    openPraiseButton
                }
                .padding(.top, 70)
            }
            .padding()
            
        }
        .background(
            background,
            alignment: .top
        )
        .onDisappear {
            navigationManager.removeLast()
        }
        .sheet(isPresented: $showAddNewEntrySheet) {
            NewEntryView(viewModel: JournalViewModel(selectedModule: .distract))
        }
    }
    
    private var background: some View {
        Image("notificationBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var doneButton: some View {
        Button{
            dismiss.callAsFunction()
        } label: {
            Text("Done")
                .foregroundStyle(Color.greenSuccess)
                .font(.poppins500, size: 16)
        }
    }
    
    private var distractImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 27)
                .foregroundStyle(Color.greenSuccess)
                .frame(width: 110, height: 110)
            
            Image("distractIcon")
                .resizable()
               
              .renderingMode(.template)
                .frame(width: 70, height: 70)
                .foregroundStyle(Color.white)
        }
    }
    
    private var wellDoneText: some View {
        Text("Well Done!")
            .foregroundStyle(Color.textDark)
            .font(.poppins700, size: 40)
    }
    
    private var sendButton: some View {
        Button {
            
        } label: {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .frame(width: 20, height: 29)
        }
    }
    
    private var infoText: some View {
        Text("You kept on going and things got better. Take a moment to notice how well you did. Keep it up!")
            .font(.poppins600, size: 18)
            .foregroundStyle(Color.textSecondary)
            .multilineTextAlignment(.center)
    }
    
    private var addJournalButton: some View {
        Button {
            showAddNewEntrySheet = true
        } label: {
            Text("Add to Journal")
                .frame(width: 238)
        }
        .buttonStyle(.mainGreenButton)
        .padding(.horizontal, 50)
    }
    
    private var openPraiseButton: some View {
        Button {
            
        } label: {
            Text("Open Praise")
                .frame(width: 238)
        }
        .buttonStyle(.mainGreenButton)
        .padding(.horizontal, 50)
    }
}

#Preview {
    WellDoneView()
        .environmentObject(NavigationManager())
        .environmentObject(ParentDataManager())
}
