//
//  NewEntryView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 19.10.2023.
//

import SwiftUI

struct NewEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var parentData: ParentDataManager
    
    @StateObject var viewModel: JournalViewModel
        
    @State private var whatHappened = ""
    @State private var whatWentWell = ""
    @State private var whatDifferent = ""
    @State private var isModulesExpanded = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    cancelButton
                    Spacer()
                }
                HStack {
                    title
                    Spacer()
                    imagePlaceholderAndText
                }
                .padding(.top, 30)
                
                if isModulesExpanded {
                    modulesContent
                        .padding(.top, 34)
                }
                
                Group {
                    filedsGroup
                        .padding(.top, 34)
                    
                    completeButton
                        .padding(.top, 50)
                }
                .blur(radius: isModulesExpanded ? 2 : 0)
                .disabled(isModulesExpanded ? true : false)
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .scrollIndicators(.hidden)
        .background(
            background,
            alignment: .top
        )
    }
    
    private var background: some View {
        Image("secondaryLargeBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss.callAsFunction()
        }
        .font(.poppins400, size: 16)
        .foregroundStyle(Color.blueAction)
        
    }
    
    private var title: some View {
        Text("New Entry")
            .font(.poppins700, size: 40)
            .foregroundStyle(Color.textDark)
    }
    
    private var imagePlaceholderAndText: some View {
        Button {
            withAnimation(.spring()) {
                isModulesExpanded.toggle()
            }
        } label: {
            entryButtonLabel
        }
        .padding(.bottom, -20)
    }
    
    private var entryButtonLabel: some View {
        VStack(spacing: 6) {
            if viewModel.selectedModule == nil {
                entryButtonImageLabel
            } else {
                sectionIcon(section: viewModel.selectedModule)
                    .frame(width: 62, height: 62)
            }
            
            Text(viewModel.selectedModule == nil ? "Module" : viewModel.selectedModule!.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.datesText)
        }
        .fixedSize()
    }
    
    private var entryButtonImageLabel: some View {
        Image("homeTabIcon")
            .renderingMode(.template)
            .resizable()
            .scaledToFill()
            .foregroundStyle(.white)
            .frame(width: 29, height: 32)
            .frame(width: 62, height: 62)
            .background(Color.blueAction)
            .clipShape(Circle())
    }
    
    private var filedsGroup: some View {
        VStack(spacing: 10) {
            MainTextEditorView(text: $whatHappened, promptText: "What Happened?", fieldHeight: 120)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.white)
                )
            
            MainTextEditorView(text: $whatWentWell, promptText: "What went well?", fieldHeight: 120)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.white)
                )
            MainTextEditorView(text: $whatDifferent, promptText: "What will I do differently next time?", fieldHeight: 120)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.white)
                )
            
        }
    }
    
    @ViewBuilder
    private var completeButton: some View {
        let childId = parentData.helpingChildren.id
        let parentId = parentData.parent?.id
        
        Button {
            viewModel.createNewEntry(selectedModule: viewModel.selectedModule, whatHappened: whatHappened, whatWentWell: whatWentWell, whatWillDoDifferent: whatDifferent, childId: childId!, parentId: parentId!)
            dismiss.callAsFunction()
        } label: {
            VStack(spacing: 8) {
                Text("Save")
                    .foregroundStyle(.black)
                    .font(.system(size: 17))
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 62, height: 62)
                    .foregroundStyle(Color.greenSuccess)
            }
        }
        .disabled(childId == nil || parentId == nil)
    }
    
    private var modulesContent: some View {
        VStack(spacing: 18) {
            Text("Please Select")
                .foregroundStyle(Color.textDark)
                .font(.poppins600, size: 18)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 15) {
                ForEach(GameSection.allCases.filter({$0 != .profiles})) { card in
                    Button {
                        viewModel.selectedModule = card
                        withAnimation(.spring()) {
                            isModulesExpanded = false
                        }
                    } label: {
                        sectionIcon(section: card)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 17)
        .card(cornerRadius: 27, shadowColor: .black.opacity(0.2))
    }
    
    private func sectionIcon(section: GameSection?) -> some View {
        Image(section?.image ?? "journalTabIcon")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.white)
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .foregroundStyle(section?.gameColor ?? Color.textSecondary)
            )
            .frame(width: 52, height: 52)
    }
}

#Preview {
    NewEntryView(viewModel: JournalViewModel())
        .environmentObject(ParentDataManager())
}
