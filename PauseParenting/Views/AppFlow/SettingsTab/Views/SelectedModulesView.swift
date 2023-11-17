//
//  SelectedModulesView.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 18.10.2023.
//

import SwiftUI

enum GameCellType {
    case included
    case more
}

struct SelectedModulesView: View {
    @StateObject var viewModel = SelectedModulesViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            includedSection
            moreSection
        }
        .environment(\.editMode, .constant(.active))
        .scrollContentBackground(.hidden)
        .navigationTitle("Selected Modules")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .background(Color.mainYellowBackground)
        .tabbarSafearea()
    }
    
    private var includedSection: some View {
        Section("INCLUDED MODULES") {
            ForEach(viewModel.includedModules) { game in
                GameCell(
                    type: .included,
                    game: game,
                    onImageTap: {
                        viewModel.replaceGame(game)
                    }
                )
                .listRowBackground(Color.yellowListBackground)
            }
            .onMove(perform: { _, _ in })
        }
    }
    
    private var moreSection: some View {
        Section("MORE MODULES") {
            ForEach(viewModel.moreModules) { game in
                GameCell(
                    type: .more,
                    game: game,
                    onImageTap: {
                        viewModel.replaceGame(game)
                    }
                )
                .listRowBackground(Color.grayListBackground)
            }
            .onMove(perform: { _, _ in })
        }
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .frame(width: 20, height: 20)
        }
    }
}

struct GameCell: View {
    let type: GameCellType
    let game: GameModel
    let onImageTap: () -> Void
    
    var body: some View {
        HStack {
            Image(type == .more ? "plusIcon" : "minusIcon")
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    onImageTap()
                }
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(game.backgroundColor)
                    .frame(width: 34, height: 34)
                Image(game.gameType.image)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: game.imageWidth, height: game.imageHeight)
            }
            type == .included ?
            Text(game.gameType.title)
                .font(.poppins600, size:  20)
                .foregroundStyle(.black)
            :
            Text(game.gameType.title)
                .font(.poppins400, size:  17)
                .foregroundStyle(.textWithOpacity)
            Spacer()
        }        
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SelectedModulesView()
}
