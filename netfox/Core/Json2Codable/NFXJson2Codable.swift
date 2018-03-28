//
//  NFXJson2Codable.swift
//  netfox_ios
//
//  Created by Ștefan Suciu on 2/13/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

public class NFXJson2Codable {
    
    private let boolParser = NFXJsonParser<Bool>()
    private let intParser = NFXJsonParser<Int>()
    private let doubleParser = NFXJsonParser<Double>()
    private let stringParser = NFXJsonParser<String>()
    private let dictionaryParser = NFXJsonParser<[String: Any]>()
    private let arrayParser = NFXJsonParser<[Any]>()
    private let urlParser = NFXJsonParser<URL>()
    private let dateParser = NFXJsonParser<Date>()
    
    private var codableClasses: [NFXCodableClass] = []
    
    func convertToCodable(name: String, from array: [Any]) -> NFXCodableClass {
        if let item = array.first, dictionaryParser.canParse(item) {
            return array.map{ convertToCodable(name: name, from: dictionaryParser.parse($0)) }.first!
        }
        
        return getCodableClass(name: convertToProperty(key: name, value: array.first!))
    }
    
    func convertToCodable(name: String, from dictionary: [String: Any]) -> NFXCodableClass {
        let codableClass = getCodableClass(name: name)
        
        dictionary.keys.forEach { key in
            let type = convertToProperty(key: key, value: dictionary[key]!)
            if type == "Int" || type == "String" {
                codableClass.addProperty(name: key, type: type, value: dictionary[key]! as? AnyHashable)
            } else {
                codableClass.addProperty(name: key, type: type)
            }
        }
        
        return codableClass
    }
    
    private func convertToProperty(key: String, value: Any) -> String {
        if boolParser.canParse(value) {
            return boolParser.getPropertyType()
        }
        
        if intParser.canParse(value) {
            if dateParser.canParse(key: key, value: intParser.parse(value)) {
                return dateParser.getPropertyType()
            }
            
            return intParser.getPropertyType()
        }
        
        if doubleParser.canParse(value) {
            return doubleParser.getPropertyType()
        }
        
        if stringParser.canParse(value) {
            let stringValue = stringParser.parse(value)
            
            if urlParser.canParse(stringValue) {
                return urlParser.getPropertyType()
            }
            
            if dateParser.canParse(stringValue) {
                return dateParser.getPropertyType()
            }
            
            return stringParser.getPropertyType()
        }
        
        if dictionaryParser.canParse(value) {
            let dictionary = dictionaryParser.parse(value)
            
            if let _ = dictionary.first {
                let _ = convertToCodable(name: key, from: dictionary)
                return dictionaryParser.getPropertyType(name: key)
            } else {
                return "Any"
            }
        }
        
        if arrayParser.canParse(value) {
            let array = arrayParser.parse(value)
            
            if let _ = array.first {
                let codableClass = convertToCodable(name: key, from: array)
                return "[\(codableClass.className)]"
            } else {
                return "[Any]"
            }
        }
        
        return "Any"
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
        guard var url = url else {
            return "ClassName"
        }
        
        url = String(url.split(separator: "?").first!)
        
        var components = url.split(separator: "/")
        if let _ = Int(components.last ?? "") {
            components = Array(components.dropLast())
        }
        
        return String(components.last ?? "")
    }
    
    func printClasses() -> String {
        return codableClasses.map{ $0.description }.joined()
    }
}
