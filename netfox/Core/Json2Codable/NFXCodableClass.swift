//
//  NFXCodableClass.swift
//  netfox_osx
//
//  Created by Ștefan Suciu on 2/13/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

fileprivate class NFXCodableProperty {
    
    var name: String
    var type: String
    var isOptional: Bool
    
    init(name: String, type: String, isOptional: Bool) {
        self.name = name
        self.type = type
        self.isOptional = isOptional
    }
}

class NFXCodableClass: CustomStringConvertible {
    
    var className: String
    fileprivate var properties: [NFXCodableProperty] = []
    
    init(className: String) {
        self.className = className
    }
    
    func addProperty(name: String, type: String) {
        if let property = properties.first(where: { $0.name == name }) {
            if property.type.contains("Any") && type != "Any" {
                property.type = type
            } else if type == "Any" {
                property.isOptional = true
            }
        } else {
            let property = NFXCodableProperty(name: name, type: type, isOptional: type == "Any")
            properties.append(property)
        }
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
    
    fileprivate func getOptional(_ isOptional: Bool) -> String {
        return isOptional ? "?" : "!"
    }
    
    var description: String {
        if properties.isEmpty {
            return className
        }
        
        var str = "class \(getClassName(className)): Codable {\n\n"
        str += properties.map{ "\tvar \(getPropertyName($0.name)): \(getPropertyType($0.type))\(getOptional($0.isOptional))" }.joined(separator: "\n")
        str += "\n\n\tenum CodingKeys: String, CodingKey {\n"
        str += properties.map{"\t\tcase \(getPropertyName($0.name)) = \"\($0.name)\""}.joined(separator: "\n")
        str += "\n\t}"
        str += "\n}\n\n"
        return str
    }
}
