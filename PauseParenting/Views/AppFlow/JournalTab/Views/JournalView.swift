//
//  JournalView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 17.10.2023.
//

import SwiftUI

struct JournalView: View {
    @EnvironmentObject private var parentData: ParentDataManager
    
    @StateObject private var viewModel = JournalViewModel()
    
    @State private var isChildPickerExpanded = false
    @State private var showNewEntrySheet = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 30) {
                    ZStack(alignment: .bottom) {
                        yellowEllipse
                        
                        VStack(spacing: 0) {
                            ZStack(alignment: .bottom) {
                                whiteEllispse
                                
                                SeparatedChildPickerView(
                                    selectedChild: $parentData.helpingChildren,
                                    isExpanded: $isChildPickerExpanded,
                                    children: parentData.children
                                )
                                .padding(.horizontal)
                                .padding(.top, 70)
                                .padding(.bottom, 30)
                            }
                            
                            newEntryField
                                .padding(.horizontal, 32)
                                .padding(.vertical, 30)
                                .padding(.bottom, 10)
                                .opacity(isChildPickerExpanded ? 0.3 : 1.0)
                        }
                    }
                    
                    journalContent
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                        .blur(radius: isChildPickerExpanded ? 2 : 0)
                        .disabled(isChildPickerExpanded ? true : false)
                }
            }
            
            .scrollIndicators(.hidden)
            
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            background,
            alignment: .top
        )
        .onAppear(perform: updateEntries)
        .sheet(isPresented: $showNewEntrySheet) {
            NewEntryView(viewModel: viewModel)
        }
        .onChange(of: parentData.helpingChildren) { _ in
            updateEntries()
        }
    }
    
    private var background: some View {
        Image("mainLargeBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var whiteEllispse: some View {
        VStack(spacing: -30) {
            Rectangle()
                .frame(height: 200)
            
            Ellipse()
                .frame(width: 803, height: 195)
               
        }
        .padding(.top, -200)
        .foregroundColor(.white)
        .frame(width: UIScreen.main.bounds.width)
    }
    
    private var yellowEllipse: some View {
        Ellipse()
            .foregroundColor(.mainYellowBackground)
            .frame(width: 1003, height: 300)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .frame(maxWidth: UIScreen.main.bounds.width)
    }
    
    private var newEntryField: some View {
        Button{
            showNewEntrySheet = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("New Entry")
                        .font(.poppins600, size: 24)
                        .foregroundStyle(Color.textDark)
                    
                    Text("Record behaviour to track ..")
                        .font(.poppins400, size: 14)
                        .foregroundStyle(Color.textDark)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("editIconImage")
                    .resizable()
                    .frame(width: 62, height: 62)
            }
        }
        .disabled(isChildPickerExpanded)
    }
    
    private var journalContent: some View {
        VStack(spacing: 36) {
            ForEach(Array(viewModel.groupedJournalEntries), id: \.key) { date, entries in
                VStack(spacing: 10) {
                    sectionDate(date: date)
                    VStack(spacing: 7) {
                        ForEach(entries.reversed(), id: \.self) { entry in
                            let isLast = entries.first == entry
                            
                            JournalEntryCardView(card: entry)
                            
                            if !isLast {
                                separateCircle
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var separateCircle: some View {
        Circle()
            .foregroundStyle(.white)
            .frame(width: 8, height: 8)
    }
    
    private func sectionDate(date: Date) -> some View {
        return Text(date.daysFormattedDate())
            .foregroundStyle(Color.datesText)
            .font(.system(size: 15, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    private func updateEntries() {
        let childId = parentData.helpingChildren.id ?? ""
        let parentId = parentData.parent?.id ?? ""
        viewModel.getEntries(childId: childId, parentId: parentId)
    }
}

#Preview {
    JournalView()
}
