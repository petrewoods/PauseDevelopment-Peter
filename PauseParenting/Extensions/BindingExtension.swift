//
//  BindingExtension.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 31.10.2023.
//

import Foundation
import SwiftUI

extension Binding where Value == Int {
     var stringBinding: Binding<String> {
         .init(
             get: {
                 if wrappedValue >= 0 {
                     return wrappedValue.description
                 } else {
                     return ""
                 }
             },
             set: { newValue in
                 if let int = Int(newValue), int >= 0 {
                     wrappedValue = int
                 } else {
                     wrappedValue = -1
                 }
             }
         )
     }
 }
