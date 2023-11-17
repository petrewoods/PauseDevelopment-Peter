//
//  IgnoreItemRepository.swift
//  PauseParenting
//
//  Created by Peter Woods on 09/11/2023.
//


//import Foundation
//
//class IgnoreItemRepository {
//    static func getEntryForChild(withId childId: String, forParentId parentId: String) -> [IgnoreItemCard] {
//        let retrievedIgnoreItems = IgnoreUserDefaults.standard.getIgnoreItemCards(forKey: .ignoreItems)
//        
//        return retrievedIgnoreItems.filter({ $0.childId == childId && $0.parentId == parentId})
//    }
//    
//    static func saveNewEntryForChild(items: IgnoreItemCard) {
//        let retrievedIgnoreItems = UserDefaults.standard.getIgnoreItemCards(forKey: .ignoreItems)
//        
//        IgnoreUserDefaults.standard.setIgnoreItemCards(retrievedIgnoreItems + [items], forKey: .ignoreItems)
//    }
//}
//
//enum UserDefaultsKeys: String {
//    case ignoreItems
//}
//
//extension UserDefaults {
//    func setIgnoreItemCards(_ cards: [IgnoreItemCard], forKey key: UserDefaultsKeys) {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(cards) {
//            self.set(encoded, forKey: key.rawValue)
//        }
//    }
//    
//    func getIgnoreItemCards(forKey key: UserDefaultsKeys) -> [IgnoreItemCard] {
//        if let ignoreItemsCardsData = self.data(forKey: key.rawValue) {
//            let decoder = JSONDecoder()
//            if let ignoreItemCards = try? decoder.decode([EntryCard].self, from: ignoreItemsCardsData) {
//                return ignoreItemCards
//            }
//        }
//        return []
//    }
//}
