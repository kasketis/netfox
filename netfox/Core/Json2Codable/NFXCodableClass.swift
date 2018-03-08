//
//  NFXCodableClass.swift
//  netfox_osx
//
//  Created by Ștefan Suciu on 2/13/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation


fileprivate class NFXCodableProperty: CustomStringConvertible {
    
    var name: String
    var type: String
    var values: [AnyHashable]
    var isOptional: Bool
    
    init(name: String, type: String, isOptional: Bool, value: AnyHashable? = nil) {
        self.name = name
        self.type = type
        self.isOptional = isOptional
        self.values = value != nil ? [value!] : []
    }
    
    fileprivate func getName() -> String {
        return name.camelCasedString
    }
    
    fileprivate func getType() -> String {
        return type.camelCasedString.uppercaseFirstLetter().singular
    }
    
    fileprivate func getOptional() -> String {
        return isOptional ? "?" : "!"
    }
    
    var description: String {
        return "\tvar \(getName()): \(getType())\(getOptional())"
    }
    
    var codingKeyDescription: String {
        return "\t\tcase \(getName()) = \"\(name)\""
    }
}


fileprivate struct NFXCodableEnum: CustomStringConvertible {
    
    var name: String
    var type: String
    var cases: [AnyHashable]
    
    fileprivate func getName() -> String {
        return name.camelCasedString.uppercaseFirstLetter().singular
    }
    
    fileprivate func getType() -> String {
        return type.camelCasedString.uppercaseFirstLetter().singular
    }
    
    init(name: String, type: String, cases: [AnyHashable]) {
        self.name = name
        self.type = type
        self.cases = cases
    }
    
    var description: String {
        var str = "enum \(getName()): \(getType()), Codable {\n"
        
        if type == "Int" {
            str += cases.map{ "\n\tcase type\($0) = \($0)" }.joined()
        } else {
            str += cases.map{ "\n\tcase \($0) = \"\($0)\"" }.joined()
        }
        
        str += "\n}\n\n"
        return str
    }
}


class NFXCodableClass: CustomStringConvertible {
    
    var className: String
    fileprivate var properties: [NFXCodableProperty] = []
    fileprivate var enums: [NFXCodableEnum] = []
    
    init(className: String) {
        self.className = className
    }
    
    fileprivate func getClassName(_ string: String) -> String {
        return string.camelCasedString.uppercaseFirstLetter().singular
    }
    
    func addProperty(name: String, type: String, value: AnyHashable? = nil) {
        if let property = properties.first(where: { $0.name == name }) {
            if property.type.contains("Any") && !type.contains("Any") {
                property.type = type
            } else if type == "Any" {
                property.isOptional = true
            }
            if let value = value {
                property.values.append(value)
            }
        } else {
            let property = NFXCodableProperty(name: name, type: type, isOptional: type == "Any", value: value)
            properties.append(property)
        }
    }
    
    func detectEnums() {
        properties.filter{ !$0.name.contains("id") && ($0.type == "Int" || $0.type == "String") && !$0.values.isEmpty }
            .forEach { (property: NFXCodableProperty) in
                let uniqueValues = Array(Set(property.values))
                
                // need a better decision mechanism
                if Double(uniqueValues.count) / Double(property.values.count) < 0.5 {
                    let codableEnum = NFXCodableEnum(name: property.name, type: property.type, cases: uniqueValues)
                    enums.append(codableEnum)
                    property.type = property.name
                }
            }
    }
    
    var description: String {
        return properties.isEmpty ? className : classDescription
    }
    
    fileprivate var classDescription: String {
        var str = enumsDescription
        str += "class \(getClassName(className)): Codable {\n\n"
        str += properties.map{ $0.description }.joined(separator: "\n")
        str += codingKeysDescription
        str += "\n}\n\n"
        return str
    }
    
    fileprivate var codingKeysDescription: String {
        var str = ""
        
        let filteredProperties = properties.filter{ $0.getName() != $0.name }
        if !filteredProperties.isEmpty {
            str += "\n\n\tenum CodingKeys: String, CodingKey {\n"
            str += filteredProperties.map{ $0.codingKeyDescription }.joined(separator: "\n")
            str += "\n\t}"
        }
        
        return str
    }
    
    fileprivate var enumsDescription: String {
        return enums.map{ $0.description }.joined()
    }
}
