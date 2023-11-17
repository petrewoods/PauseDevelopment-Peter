//
//  ParentDetailType.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 27.10.2023.
//

import Foundation

enum ParentDetailType: String, CaseIterable, Identifiable, Equatable {
    var id: Self { self }
    
    case whatIdoToRelax, whatMakesMeStressed
    
    var title: String {
        switch self {
        case .whatIdoToRelax: return "What I do to relax"
        case .whatMakesMeStressed: return "What makes me stressed"
        }
    }
}
