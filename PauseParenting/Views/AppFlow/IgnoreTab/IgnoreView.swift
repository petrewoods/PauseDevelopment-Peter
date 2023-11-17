//
//  IgnoreView2.swift
//  PauseParenting
//
//  Created by Peter Woods on 13/11/2023.
//


import SwiftUI

struct IgnoreView: View {
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var showingIgnore = false
    @EnvironmentObject private var parentData: ParentDataManager
    
    
    @State private var isChildPickerExpanded = false
    @State private var itemsToIgnore: [String] = []
    @State private var goal1 = ""
    @State private var goal2 = ""
    @State private var goal3 = ""
    @State private var ignoreGoal: String = UserDefaults.standard.string(forKey: "ignoreGoal") ?? "default goals"
    
    var body: some View {
        
  
        ScrollView{
            VStack(spacing: 52) {
                header
                ChildPickerView(
                    selectedChild: $parentData.helpingChildren,
                    isExpanded: $isChildPickerExpanded,
                    children: parentData.children
                )
                
                .padding(.top, 8)
                .padding(.horizontal, 19)
                
                
                // TODO: Need to make ?userdefaults to make this child's ignoring goals readable and editable
                
                Text("Behaviours i'm working on ignoring. \nThese will be editable shortly")
                    .font(.system(size: 16, weight: .regular))
                    .minimumScaleFactor(0.1)
                    .foregroundStyle(Color.textSecondary)
                    .padding(.horizontal, 22)
                    .frame(maxWidth: .infinity, alignment: .leading)
              
                goalsGroup
                    .padding()
            }
                            startIgnore
               
            .sheet(isPresented: $showingIgnore) {
                SecondIgnoreView()
            }
                    
                }
            
            
        
        .background(
            background,
            alignment: .top
        )
        .scrollBounceBehavior(.basedOnSize)
        
    }

    
    private var header: some View {
        
        Text("IGNORE")
            .font(.poppins700, size: 32)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .padding(.horizontal, 28)
            .padding(.top, 22)
            .foregroundStyle(Color.textDark)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
   
    private var goalsGroup: some View {
        VStack(spacing: 10) {
            SecondaryTextEditorView(text: $goal1, promptText: "First Goal", fieldHeight: 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.white)
                )
            SecondaryTextEditorView(text: $goal2, promptText: "Second Goal", fieldHeight: 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.white)
                )
            SecondaryTextEditorView(text: $goal3, promptText: "Third Goal", fieldHeight: 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.white)
                )
        }
    }
    
    
    
    private var startIgnore: some View {
        Button{
            showingIgnore = true
        } label: {
            HStack{
                Text("Start Ignore")
                Spacer()
                Image("playIcon")
                    .padding()
            }
        }
        .buttonStyle(.darkGreenButton)
        .padding(.horizontal, 40)
    }
        
    
    
    private var background: some View {
        Image("mainLargeBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    
}



#Preview {
    NavigationStack {
        IgnoreView()
            .environmentObject(NavigationManager())
            .environmentObject(ParentDataManager())
    }
}
