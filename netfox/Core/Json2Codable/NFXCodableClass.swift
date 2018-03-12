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
    var properties: [(name: String, type: String)] = []
    
    init(className: String) {
        self.className = className
    }
    
    func addProperty(name: String, type: String) {
        if let index = properties.index(where: { $0.name == name }) {
            if properties[index].type == "Any" && type != "Any" {
                properties[index].type = type
            }
        } else {
            properties.append((name, type))
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
    
    var description: String {
        if properties.isEmpty {
            return className
        }
        
        var str = "class \(getClassName(className)): Codable {\n\n"
        str += properties.map{ "\tvar \(getPropertyName($0.name)): \(getPropertyType($0.type))!" }.joined(separator: "\n")
        str += "\n\n\tenum CodingKeys: String, CodingKey {\n"
        str += properties.map{"\t\tcase \(getPropertyName($0.name)) = \"\($0.name)\""}.joined(separator: "\n")
        str += "\n\t}"
        str += "\n}\n\n"
        return str
    }
}
