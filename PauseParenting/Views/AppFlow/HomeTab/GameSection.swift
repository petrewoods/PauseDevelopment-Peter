//
//  GameSection.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 19.10.2023.
//

import Foundation
import SwiftUI

enum GameSection: CaseIterable, Identifiable, Codable {
    case timeOut, quickTime, relaxTogether, distract, ignore, chart, profiles, consequences, praise
    
    var id: String {
        return title
    }
    
    var title: String {
        switch self {
        case .timeOut: "Time Out"
        case .quickTime: "Quick Timer"
        case .relaxTogether: "Relax Together"
        case .distract: "Distract"
        case .ignore: "Ignore"
        case .chart: "Chart"
        case .profiles: "Profiles"
        case .consequences: "Consequences"
        case .praise: "Praise"
        }
    }
    
    var image: String {
        switch self {
        case .timeOut: "timeOutIcon"
        case .quickTime: "quickTimerIcon"
        case .relaxTogether: "relaxTogetherIcon"
        case .distract: "distractIcon"
        case .ignore: "ignoreIcon"
        case .chart: "chartIcon"
        case .profiles: "profilesIcon"
        case .consequences: "consequenceIcon"
        case .praise: "praiseIcon"
        }
    }
    
    var gameColor: Color {
        switch self {
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
    
    var fontSize: CGFloat {
        switch self {
        case .timeOut, .distract, .ignore, .chart, .praise, .profiles:
            return 16
        case .quickTime, .relaxTogether, .consequences:
            return 13
        }
    }
}
