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
    
    var description: String {
        var str = "class \(className.camelCasedString.singular): Codable {\n\n"
        str += properties.map{ "\tvar \($0.0.camelCasedString.lowercaseFirstLetter()): \($0.1.camelCasedString.singular)!" }.joined(separator: "\n")
        str += "\n\n\tenum CodingKeys: String, CodingKey {\n"
        str += properties.map{"\t\tcase \($0.0.camelCasedString.lowercaseFirstLetter()) = \"\($0.0)\""}.joined(separator: "\n")
        str += "\n\t}"
        str += "\n}\n\n"
        return str
    }
}
