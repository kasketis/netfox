//
//  String+CamelCase.swift
//  netfox_osx
//
//  Created by Ștefan Suciu on 2/13/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

extension String {
    
    func uppercaseFirstLetter() -> String {
        if hasPrefix("[") && hasSuffix("]") {
            let leadingParanthesisCount = components(separatedBy: "[").count - 1
            let endingParanthesisCount = components(separatedBy: "]").count - 1
            let startIndex = index(self.startIndex, offsetBy: leadingParanthesisCount)
            let endIndex = index(self.endIndex, offsetBy: -endingParanthesisCount)
            let stringWithoutParanthesis = self[startIndex..<endIndex]
            let leadingParanthesis = String(repeating: "[", count: leadingParanthesisCount)
            let endingParanthesis = String(repeating: "]", count: endingParanthesisCount)
            
            return leadingParanthesis + stringWithoutParanthesis.prefix(1).capitalized + stringWithoutParanthesis.dropFirst() + endingParanthesis
        } else {
            return prefix(1).capitalized + dropFirst()
        }
    }
    
    func lowercaseFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    func replacingLastOccurences(of searchString: String, with replacementString: String) -> String {
        if let range = self.range(of: searchString, options: [.backwards, .caseInsensitive]) {
            return self.replacingCharacters(in: range, with: replacementString)
        }
        
        return self
    }
    
    var camelCasedString: String {
        let splittedComponents = components(separatedBy: CharacterSet(charactersIn: "_- "))
        return splittedComponents.first! + splittedComponents.dropFirst().map{ $0.uppercaseFirstLetter() }.joined()
    }
    
    var singular: String {
        let paranthesisCount = components(separatedBy: "]").count - 1
        let stringWithoutParanthesis = dropLast(paranthesisCount)
        
        if stringWithoutParanthesis.hasSuffix("ies") {
            return replacingLastOccurences(of: "ies", with: "y")
        }
        
        if stringWithoutParanthesis.hasSuffix("s") {
            return stringWithoutParanthesis.dropLast() + String(repeating: "]", count: paranthesisCount)
        }
        
        return self
    }
}
