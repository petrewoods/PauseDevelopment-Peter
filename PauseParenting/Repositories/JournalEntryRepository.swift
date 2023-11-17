//
//  JournalEntryRepository.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 31.10.2023.
//

import Foundation

class JournalEntryRepository {
    static func getEntryForChild(withId childId: String, forParentId parentId: String) -> [EntryCard] {
        let retrievedEntries = UserDefaults.standard.getEntryCards(forKey: .journalEntries)
        
        return retrievedEntries.filter({ $0.childId == childId && $0.parentId == parentId})
    }
    
    static func saveNewEntryForChild(entry: EntryCard) {
        let retrievedEntries = UserDefaults.standard.getEntryCards(forKey: .journalEntries)
        
        UserDefaults.standard.setEntryCards(retrievedEntries + [entry], forKey: .journalEntries)
    }
}

enum UserDefaultsKeys: String {
    case journalEntries, images
}

extension UserDefaults {
    func setEntryCards(_ cards: [EntryCard], forKey key: UserDefaultsKeys) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cards) {
            self.set(encoded, forKey: key.rawValue)
        }
    }
    
    func getEntryCards(forKey key: UserDefaultsKeys) -> [EntryCard] {
        if let entryCardsData = self.data(forKey: key.rawValue) {
            let decoder = JSONDecoder()
            if let entryCards = try? decoder.decode([EntryCard].self, from: entryCardsData) {
                return entryCards
            }
        }
        return []
    }
}
