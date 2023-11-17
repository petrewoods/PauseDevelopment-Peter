//
//  GameModel.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 18.10.2023.
//

import Foundation
import SwiftUI

struct GameModel: Identifiable, Equatable {
    var id = UUID()
    var gameType: GameSection
    var isIncluded: Bool
    
    var imageWidth: CGFloat {
        switch gameType {
        case .ignore: return 22.5
        case .chart: return 22
        case .relaxTogether: return 28
        case .distract: return 25
        case .profiles: return 22
        case .consequences: return 20
        case .praise: return 22
        case .timeOut: return 21.5
        case .quickTime: return 26
        }
    }
    
    var imageHeight: CGFloat {
        switch gameType {
        case .ignore: return 22.5
        case .chart: return 22
        case .relaxTogether: return 20
        case .distract: return 25
        case .profiles: return 23.5
        case .consequences: return 26
        case .praise: return 27
        case .timeOut: return 24
        case .quickTime: return 22
        }
    }
    
    var backgroundColor: Color {
        switch gameType {
        case .ignore: return .ignore
        case .chart: return .chart
        case .relaxTogether: return .relaxTogether
        case .distract: return .distract
        case .profiles: return .profiles
        case .consequences: return .consequences
        case .praise: return .praise
        case .timeOut: return .timeOut
        case .quickTime: return .timeOut
        }
    }
    
    static let allGamesMock: [GameModel] = GameSection.allCases.enumerated().map { index, section in
        GameModel(gameType: section, isIncluded: (index % 2 == 0))
    }
}
