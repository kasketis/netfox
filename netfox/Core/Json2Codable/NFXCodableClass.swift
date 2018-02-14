//
//  NFXCodableClass.swift
//  netfox_osx
//
//  Created by Ștefan Suciu on 2/13/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

class NFXCodableClass: CustomStringConvertible {
    
    var className: String
    var properties: [(String, String)] = []
    
    init(className: String) {
        self.className = className
    }
    
    func addProperty(name: String, type: String) {
        properties.append((name, type))
    }
    
    fileprivate func getClassName(_ string: String) -> String {
        return string.camelCasedString.uppercaseFirstLetter().singular
    }
    
    fileprivate func getPropertyName(_ string: String) -> String {
        return string.camelCasedString
    }
    
    fileprivate func getPropertyType(_ string: String) -> String {
        return string.camelCasedString.uppercaseFirstLetter().singular
    }
    
    var description: String {
        if properties.isEmpty {
            return className
        }
        
        var str = "class \(getClassName(className)): Codable {\n\n"
        str += properties.map{ "\tvar \(getPropertyName($0.0)): \(getPropertyType($0.1))!" }.joined(separator: "\n")
        str += "\n\n\tenum CodingKeys: String, CodingKey {\n"
        str += properties.map{"\t\tcase \(getPropertyName($0.0)) = \"\($0.0)\""}.joined(separator: "\n")
        str += "\n\t}"
        str += "\n}\n\n"
        return str
    }
}
