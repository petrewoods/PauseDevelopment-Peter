//
//  PersonImage.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 19.10.2023.
//

import SwiftUI

struct PersonImage: View {
    let image: String?
    let color: Color
    let size: CGFloat
    var newSelectedImage: UIImage? = nil
    var lineWidth: CGFloat = 4
    var editAction: (() -> ())? = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = newSelectedImage ?? ImageRepository.getImage(id: image) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .clipped()
            } else {
                placeholder
            }
            
            Circle()
                .stroke(color, lineWidth: lineWidth)
            
            if let editAction {
                Button(action: editAction) {
                    Image("editIconImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .contentShape(Rectangle())
                        .padding(-3)
                }
            }
        }
        .frame(width: size, height: size)
    }
    
    private var placeholder: some View {
        ZStack {
            Circle()
                .fill(Color.blueAction)
            
            Image(systemName: "person")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .padding(16)
                .foregroundStyle(color)
        }
        .clipShape(Circle())
    }
}

#Preview {
    VStack {
        PersonImage(image: "alexPhoto", color: Color.yellow, size: 130)
            .frame(width: 130, height: 130)
        
        PersonImage(image: "alexPhoto", color: Color.yellow, size: 130, editAction: {})
            .frame(width: 130, height: 130)
    }
}
