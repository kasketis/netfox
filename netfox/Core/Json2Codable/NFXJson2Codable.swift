//
//  NFXJson2Codable.swift
//  netfox_ios
//
//  Created by Ștefan Suciu on 2/13/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

public class NFXJson2Codable {
    
    private let intParser = NFXJsonParser<Int>()
    private let stringParser = NFXJsonParser<String>()
    private let doubleParser = NFXJsonParser<Double>()
    private let dictionaryParser = NFXJsonParser<[String: Any]>()
    private let arrayParser = NFXJsonParser<[Any]>()
    
    private var codableClasses: [NFXCodableClass] = []
    
    func convertToCodable(name: String, from array: [Any]) -> NFXCodableClass {
        if let item = array.first, dictionaryParser.canParse(item) {
            return convertToCodable(name: name, from: dictionaryParser.parse(item))
        }
        return NFXCodableClass(className: "Oops!")
    }
    
    func convertToCodable(name: String, from dictionary: [String: Any]) -> NFXCodableClass {
        let codableClass = getCodableClass(name: name)
        
        dictionary.keys.forEach { key in
            codableClass.addProperty(
                name: key,
                type: convertToProperty(key: key, value: dictionary[key]!)
            )
        }
        
        return codableClass
    }
    
    private func convertToProperty(key: String, value: Any) -> String {
        if intParser.canParse(value) {
            return intParser.getPropertyType()
        } else if doubleParser.canParse(value) {
            return doubleParser.getPropertyType()
        } else if stringParser.canParse(value) {
            return stringParser.getPropertyType()
        } else if dictionaryParser.canParse(value) {
            let _ = convertToCodable(name: key, from: dictionaryParser.parse(value))
            return dictionaryParser.getPropertyType(name: key)
        } else if arrayParser.canParse(value) {
            return "[\(convertToProperty(key: key, value: arrayParser.parse(value).first!))]"
        }
        
        return ""
    }
    
    private func getCodableClass(name: String) -> NFXCodableClass {
        var codableClass: NFXCodableClass
        
        if let foundClass = codableClasses.first(where: { $0.className == name }) {
            codableClass = foundClass
        } else {
            codableClass = NFXCodableClass(className: name)
            codableClasses.append(codableClass)
        }
        
        return codableClass
    }
    
    func getResourceName(from url: String?) -> String {
        guard let url = url else {
            return "ClassName"
        }
        
        var components = url.split(separator: "/")
        if let _ = Int(components.last ?? "") {
            components = Array(components.dropLast())
        }
        
        return String(components.last ?? "").singular
    }
    
    func printClasses() -> String {
        return codableClasses.map{ $0.description }.reduce("", +)
    }
}
