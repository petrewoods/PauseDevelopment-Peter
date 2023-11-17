//
//  ColorExtension.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 06.10.2023.
//

import SwiftUI

extension Color {
    static let textDark = Color("textDark")
    static let textSecondary = Color("textSecondary")
    static let mainYellowBackground = Color("mainYellowBackground")
    static let grayBackground = Color("grayBackground")
    static let greenSuccess = Color("greenSuccess")
    static let darkBlue = Color("darkBlue")
    static let blueAction = Color("blueAction")
    static let mainTextGray = Color("mainTextGray")
    static let secondaryTextGray = Color("secondaryTextGray")
    static let mainOrange = Color("mainOrange")
    static let ignore = Color("ignore")
    static let chart = Color("chart")
    static let relaxTogether = Color("relaxTogether")
    static let distract = Color("distract")
    static let profiles = Color("profiles")
    static let consequences = Color("consequences")
    static let praise = Color("praise")
    static let timeOut = Color("timeOut")
    static let textWithOpacity = Color("textWithOpacity")
    static let grayListBackground = Color("grayListBackground")
    static let yellowListBackground = Color("yellowListBackground")
    static let datesText = Color("dateTextColor")
    static let relaxBlueBackground = Color("relaxBlueBackground")
    static let distractYellowBackground = Color("distractYellowBackground")
    static let buttonBackground = Color("buttonBackground")
    static let blindRelaxButton = Color("blindRelaxButton")
    static let mintGreen = Color("mintGreen")
    static let deleteAction = Color("deleteAction")
    static let sureAlertColor = Color("sureAlertColor")
}

extension Color: Codable {
    init(hex: String) {
        let rgba = hex.toRGBA()
        self.init(
            .sRGB,
            red: Double(rgba.r),
            green: Double(rgba.g),
            blue: Double(rgba.b),
            opacity: Double(rgba.alpha)
        )
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hex = try container.decode(String.self)
        self.init(hex: hex)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(toHex)
    }
    
    var toHex: String? {
        return toHex()
    }
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor?.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(
                format: "%02lX%02lX%02lX%02lX",
                lroundf(r * 255),
                lroundf(g * 255),
                lroundf(b * 255),
                lroundf(a * 255)
            )
        } else {
            return String(
                format: "%02lX%02lX%02lX",
                lroundf(r * 255),
                lroundf(g * 255),
                lroundf(b * 255)
            )
        }
    }
}

extension String {
    func toRGBA() -> (r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        var hexSanitized = self.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        let length = hexSanitized.count
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        }
        
        return (r, g, b, a)
    }
}
