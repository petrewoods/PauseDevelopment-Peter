//
//  DateExtension.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 20.10.2023.
//

import Foundation

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter.cached(withFormat: format)
        
        return formatter.string(from: self)
    }
    
    func convertDateWithTime() -> String {        
        return self.format("dd/MM/yyyy , HH:mm")
    }
    
    func daysFormattedDate() -> String {
        return self.format("dd/MM/yyyy")
    }
    
    func groupFormat(dateComponents: Set<Calendar.Component>) -> Date {
        let components = Calendar.current.dateComponents(dateComponents, from: self)
        
        return Calendar.current.date(from: components) ?? Date()
    }
}
