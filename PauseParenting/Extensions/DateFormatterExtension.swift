//
//  DateFormatterExtension.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 20.10.2023.
//

import Foundation

extension DateFormatter {
    @Atomic static var cachedFormatters = [String: DateFormatter]()
    
    static let cacheDateFormatterLock = NSLock()
    
    static func cached(withFormat format: String) -> DateFormatter {
        if let cachedFormatter = cachedFormatters[format] {
            return cachedFormatter
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        cachedFormatters[format] = formatter
        
        return formatter
    }
}
