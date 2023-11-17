//
//  UIApplicationExtension.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 09.10.2023.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
