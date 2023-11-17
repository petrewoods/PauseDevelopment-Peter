//
//  ScreenUtils.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 07.10.2023.
//

import Foundation
import SwiftUI

struct ScreenUtils {
    static var width: CGFloat { UIScreen.main.bounds.width }
    static var height: CGFloat { UIScreen.main.bounds.height }
    static var bottomBarHeight: CGFloat { UIApplication.bottomBarHeight }
    static var isVerySmallDisplay: Bool { height < 700 }
    static var isSmallDisplay: Bool { height < 815 }
}

extension UIApplication {
    static private var bottomBarCache = CGFloat()
    
    static var bottomBarHeight: CGFloat {
            let window = UIApplication.shared.keyWindow
            
            let height = window?.safeAreaInsets.bottom ?? 0
            bottomBarCache = max(bottomBarCache, height)
            
            return bottomBarCache
        }
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
