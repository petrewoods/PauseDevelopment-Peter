//
//  ChildDetailType.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 19.10.2023.
//

import Foundation

enum ChildDetailType: String, CaseIterable, Identifiable, Equatable {
    var id: Self { self }
    
    case developmentalAge, whatCalmsMeDown, whatAmIGoodAt, whatDoIFindHard, whatDoILoveFromMyParents
    
    var title: String {
        switch self {
        case .developmentalAge: return "Developmental Age"
        case .whatCalmsMeDown: return "What Calms Me Down?"
        case .whatAmIGoodAt: return "What am I good at?"
        case .whatDoIFindHard: return "What do I find hard"
        case .whatDoILoveFromMyParents: return "What do I Love from my parents?"
        }
    }
}
