//
//  JournalViewModel.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 19.10.2023.
//

import Foundation
import OrderedCollections

final class JournalViewModel: ObservableObject {
    @Published var journalEntries: [EntryCard] = []
    @Published var groupedJournalEntries: OrderedDictionary<Date, [EntryCard]> = OrderedDictionary<Date, [EntryCard]>()
    
    @Published var selectedModule: GameSection?
    
    init(selectedModule: GameSection? = nil) {
        self.selectedModule = selectedModule
    }
    
    func groupEntries() {
        let entries = OrderedDictionary(grouping: journalEntries) {
            $0.date.groupFormat(dateComponents: [.day, .month, .year])
          }
        
        groupedJournalEntries = OrderedDictionary(uniqueKeysWithValues: entries.sorted { $0.key > $1.key })
    }
    
    func createNewEntry(selectedModule: GameSection?, whatHappened: String, whatWentWell: String, whatWillDoDifferent: String, childId: String, parentId: String) {
        let newEntry = EntryCard(
            childId: childId,
            parentId: parentId,
            selectedSection: selectedModule,
            date: Date.now,
            activityDidIDo: selectedModule?.title,
            whatHappened: whatHappened,
            whatWentWell: whatWentWell,
            whatWillDoDifferent: whatWillDoDifferent
        )
        
        addJournalEntry(newEntry, childId: childId, parentId: parentId)
    }
    
    func getEntries(childId: String, parentId: String) {
        journalEntries = JournalEntryRepository.getEntryForChild(withId: childId, forParentId: parentId)
        
        groupEntries()
    }
    
    func addJournalEntry(_ entry: EntryCard, childId: String, parentId: String) {
        JournalEntryRepository.saveNewEntryForChild(entry: entry)
        getEntries(childId: childId, parentId: parentId)
    }
}
