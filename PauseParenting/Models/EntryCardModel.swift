//
//  EntryCardModel.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 19.10.2023.
//

import Foundation

struct EntryCard: Hashable, Codable {
    let childId: String
    let parentId: String
    let selectedSection: GameSection?
    let date: Date
    let activityDidIDo: String?
    let whatHappened: String?
    let whatWentWell: String?
    let whatWillDoDifferent: String?
    
    static var mockCard: EntryCard {
        EntryCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", selectedSection: .distract, date: Date.now, activityDidIDo: "something i did", whatHappened: "something happened", whatWentWell: "something went well", whatWillDoDifferent: "something I will do different")
    }
    
    static var mockCards: [EntryCard] {
        [EntryCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", selectedSection: .distract, date: Date(), activityDidIDo: "something i did", whatHappened: "something happened", whatWentWell: "something went well", whatWillDoDifferent: "something I will do different"),
         EntryCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", selectedSection: .ignore, date: Date(), activityDidIDo: "another thing I did", whatHappened: "another thing happened", whatWentWell: "another thing went well", whatWillDoDifferent: "another thing I will do different"),
         EntryCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", selectedSection: .quickTime, date: Date().addingTimeInterval(24*60*60), activityDidIDo: "third thing I did", whatHappened: "third thing happened", whatWentWell: "third thing went well", whatWillDoDifferent: "third thing I will do different"),
         EntryCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", selectedSection: .relaxTogether, date: Date().addingTimeInterval(24*60*60), activityDidIDo: "fourth thing I did", whatHappened: "fourth thing happened", whatWentWell: "fourth thing went well", whatWillDoDifferent: "fourth thing I will do different"),
         EntryCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", selectedSection: .praise, date: Date().addingTimeInterval(2*24*60*60), activityDidIDo: "fifth thing I did", whatHappened: "fifth thing happened", whatWentWell: "fifth thing went well", whatWillDoDifferent: "fifth thing I will do different")]
    }
}
