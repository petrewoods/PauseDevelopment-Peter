//
//  EditImageView.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 27.10.2023.
//

import SwiftUI

struct EditImageView: View {
    let image: String?
    @Binding var personColor: Color
    let onSelect: (UIImage) -> ()
    
    @State private var isImagePickerPresent: Bool = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            PersonImage(
                image: image,
                color: personColor,
                size: 130,
                newSelectedImage: selectedImage
            )
            .overlay(alignment: .topTrailing) {
                CustomColorPickerView(colorValue: $personColor)
            }
            
            Button {
                isImagePickerPresent = true
            } label: {
                Text("Chose new photo")
                    .font(.poppins500, size: 18)
                    .foregroundStyle(Color.blueAction)
            }
        }
        .padding(.vertical, 93)
        .frame(maxWidth: .infinity)
        .imagePicker(isPresented: $isImagePickerPresent) { image in
            selectedImage = image
            onSelect(image)
        }
    }
}

#Preview {
    EditImageView(image: "hannahImage", personColor: .constant(.darkBlue), onSelect: { _ in })
}
