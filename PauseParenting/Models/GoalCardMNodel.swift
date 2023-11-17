//
//  GoalCardMNodel.swift
//  PauseParenting
//
//  Created by Peter Woods on 09/11/2023.
//


import Foundation

struct IgnoreItemCard: Hashable, Codable {
    let childId: String
    let parentId: String
    let itemIgnore: String?
    
    
    static var mockCard: IgnoreItemCard {
        IgnoreItemCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", itemIgnore: "my goals")
    }
    
    static var mockCards: [IgnoreItemCard] {
        [IgnoreItemCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", itemIgnore: "my goal 1" ),
         IgnoreItemCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", itemIgnore: "my goal 2"),
         IgnoreItemCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", itemIgnore: "my goal 3 "),
         IgnoreItemCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", itemIgnore: "my goal 4"),
         IgnoreItemCard(childId: "jk43Qkfjdaj42jkf2", parentId: "kja582Hf1f1f5Fjfkw", itemIgnore: "my goal 5")]
    }
}
