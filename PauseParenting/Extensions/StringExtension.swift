//
//  StringExtension.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 31.10.2023.
//

import Foundation

extension String {
    var postcodeFormat: String {
        let regexPattern = #"[^a-zA-Z0-9]"#
        
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: [])
            let postcode = regex.stringByReplacingMatches(
                in: self,
                options: [],
                range: NSRange(
                    location: 0,
                    length: self.utf16.count
                ),
                withTemplate: ""
            )
            
            return postcode
        } catch {
            print("[Error][String] postcodeFormat: \(error)")
            return self
        }
    }
    var postcodeValid: Bool {
        let regex = #"^GIR 0AA|((AB|AL|B|BA|BB|BD|BH|BL|BN|BR|BS|BT|CA|CB|CF|CH|CM|CO|CR|CT|CV|CW|DA|DD|DE|DG|DH|DL|DN|DT|DY|E|EC|EH|EN|EX|FK|FY|G|GL|GY|GU|HA|HD|HG|HP|HR|HS|HU|HX|IG|IM|IP|IV|JE|KA|KT|KW|KY|L|LA|LD|LE|LL|LN|LS|LU|M|ME|MK|ML|N|NE|NG|NN|NP|NR|NW|OL|OX|PA|PE|PH|PL|PO|PR|RG|RH|RM|S|SA|SE|SG|SK|SL|SM|SN|SO|SP|SR|SS|ST|SW|SY|TA|TD|TF|TN|TQ|TR|TS|TW|UB|W|WA|WC|WD|WF|WN|WR|WS|WV|YO|ZE)(\d[\dA-Z]?\d[ABD-HJLN-UW-Z]{2}))|BFPO \d{1,4}$"#

        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let range = NSRange(location: 0, length: self.utf16.count)
            
            return regex.firstMatch(in: self, options: [], range: range) != nil
        } catch {
            print("[Error][postcodeValid] error: \(error)")
            return false
        }
    }
}
