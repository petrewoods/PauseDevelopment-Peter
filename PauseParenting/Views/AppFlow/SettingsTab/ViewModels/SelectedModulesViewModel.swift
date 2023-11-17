//
//  SelectedModulesViewModel.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 18.10.2023.
//

import Foundation
import SwiftUI

class SelectedModulesViewModel: ObservableObject {
    @Published var includedModules: [GameModel] = []
    @Published var moreModules: [GameModel] = []
    
    init() {
        initialData()
    }
    
    private func initialData() {
        let allGamesMock = GameModel.allGamesMock
        for game in allGamesMock {
            if game.isIncluded {
                includedModules.append(game)
            } else {
                moreModules.append(game)
            }
        }
    }
    
    func replaceGame(_ game: GameModel) {
        withAnimation(.linear(duration: 0.12)) {
            if let index = includedModules.firstIndex(where: { $0 == game }) {
                var movedGame = includedModules.remove(at: index)
                moreModules.append(movedGame)
                movedGame.isIncluded.toggle()
            } else if let index = moreModules.firstIndex(where: { $0 == game }) {
                var movedGame = moreModules.remove(at: index)
                includedModules.append(movedGame)
                movedGame.isIncluded.toggle()
            }
        }
    }
}
