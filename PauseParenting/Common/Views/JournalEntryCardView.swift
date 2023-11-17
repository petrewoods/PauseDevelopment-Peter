//
//  JournalEntryCardView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 19.10.2023.
//

import SwiftUI

struct JournalEntryCardView: View {
    @State private var isExpanded = false
    let card: EntryCard
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 15) {
                sectionIcon
                VStack(alignment: .leading, spacing: 2) {
                    sectionTitle
                    if isExpanded {
                        dateText
                    }
                }
                Spacer()
            }
            if isExpanded {
                activityIDidSection
                whatHappenedSection
                whatWentWellSection
                whatIWillDoDifferentSection
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 17)
        .background(
            RoundedRectangle(cornerRadius: 27)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.1), radius: 10)
                .overlay(
                    Image("koalaImage"),
                    alignment: .bottomTrailing
                )
        )
        .onTapGesture {
            withAnimation(.spring()) {
                isExpanded.toggle()
            }
        }
    }
    
    private var sectionIcon: some View {
        Image(card.selectedSection?.image ?? "journalTabIcon")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.white)
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .foregroundStyle(card.selectedSection?.gameColor ?? Color.textSecondary)
            )
            .frame(width: 52, height: 52)
    }
    
    private var sectionTitle: some View {
        Text(card.selectedSection?.title ?? "Entry")
            .foregroundStyle(Color.textDark)
            .font(.poppins600, size: 24)
    }
    
    private var dateText: some View {
        Text(card.date.convertDateWithTime())
            .foregroundStyle(Color.textDark)
            .font(.poppins400, size: 14)
    }
    
    private var activityIDidSection: some View {
        VStack(spacing: 2) {
            Text("What activity did i do?")
                .foregroundStyle(Color.textDark)
                .font(.poppins600, size: 18)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(card.activityDidIDo ?? "")
                .foregroundStyle(Color.textDark)
                .font(.poppins400, size: 14)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var whatHappenedSection: some View {
        VStack(spacing: 2) {
            Text("What happened?")
                .foregroundStyle(Color.textDark)
                .font(.poppins600, size: 18)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(card.whatHappened ?? "")
                .foregroundStyle(Color.textDark)
                .font(.poppins400, size: 14)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var whatWentWellSection: some View {
        VStack(spacing: 2) {
            Text("What went well?")
                .foregroundStyle(Color.textDark)
                .font(.poppins600, size: 18)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(card.whatWentWell ?? "")
                .foregroundStyle(Color.textDark)
                .font(.poppins400, size: 14)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var whatIWillDoDifferentSection: some View {
        VStack(spacing: 2) {
            Text("What will I do differently next time?")
                .foregroundStyle(Color.textDark)
                .font(.poppins600, size: 18)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(card.whatWillDoDifferent ?? "")
                .foregroundStyle(Color.textDark)
                .font(.poppins400, size: 14)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    JournalEntryCardView(card: EntryCard.mockCard)
        .padding(.horizontal)
}
