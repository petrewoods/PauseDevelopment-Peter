//
//  CustomFont.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 06.10.2023.
//

import Foundation
import SwiftUI

enum CustomFont: String, CaseIterable, Identifiable, Equatable {
    var id: RawValue { rawValue }
    
    case poppins100, poppins200, poppins300, poppins400, poppins500, poppins600, poppins700, poppins800, poppins900
    
    
    public func font(_ size: CGFloat) -> Font {
        switch self {
        case .poppins100: return .custom("Poppins-Thin", fixedSize: size)
        case .poppins200: return .custom("Poppins-ExtraLight", fixedSize: size)
        case .poppins300: return .custom("Poppins-Light", fixedSize: size)
        case .poppins400: return .custom("Poppins-Regular", fixedSize: size)
        case .poppins500: return .custom("Poppins-Medium", fixedSize: size)
        case .poppins600: return .custom("Poppins-SemiBold", fixedSize: size)
        case .poppins700: return .custom("Poppins-Bold", fixedSize: size)
        case .poppins800: return .custom("Poppins-ExtraBold", fixedSize: size)
        case .poppins900: return .custom("Poppins-Black", fixedSize: size)
        }
    }
    
    public func uiFont(_ size: CGFloat) -> UIFont {
        switch self {
        case .poppins100: return UIFont(name: "Poppins-Thin", size: size)!
        case .poppins200: return UIFont(name: "Poppins-ExtraLight", size: size)!
        case .poppins300: return UIFont(name: "Poppins-Light", size: size)!
        case .poppins400: return UIFont(name: "Poppins-Regular", size: size)!
        case .poppins500: return UIFont(name: "Poppins-Medium", size: size)!
        case .poppins600: return UIFont(name: "Poppins-SemiBold", size: size)!
        case .poppins700: return UIFont(name: "Poppins-Bold", size: size)!
        case .poppins800: return UIFont(name: "Poppins-ExtraBold", size: size)!
        case .poppins900: return UIFont(name: "Poppins-Black", size: size)!
        }
    }
}

extension Text {
    func font(_ customFont: CustomFont, size: CGFloat) -> Text {
        font(customFont.font(size))
    }
}

extension View {
    func font(_ customFont: CustomFont, size: CGFloat) -> some View {
        font(customFont.font(size))
    }
}

#Preview {
    VStack(spacing: 8) {
        ForEach(CustomFont.allCases) { font in
            Text("Some text example")
                .font(font, size: 22)
        }
    }
}
