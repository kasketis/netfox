//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

extension String {
    
    func uppercaseFirstLetter() -> String {
        if let index = index(where: { CharacterSet.letters.contains($0.unicodeScalars.first!) })?.encodedOffset {
            return prefix(index) + suffix(count-index).capitalized
        }
        return prefix(1).uppercased() + dropFirst()
    }
    
    func lowercaseFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    var camelCasedString: String {
        return components(separatedBy: CharacterSet(charactersIn: "_ ")).map{ $0.lowercased().uppercaseFirstLetter() }.joined()
    }
    
    var singular: String {
        let paranthesisCount = components(separatedBy: "]").count - 1
        let stringWithoutParanthesis = dropLast(paranthesisCount)
        
        if stringWithoutParanthesis.last == "s" {
            return stringWithoutParanthesis.dropLast() + String(repeating: "]", count: paranthesisCount)
        }
        
        return self
    }
}

class Parser<T> {

    func canParse(_ value: Any) -> Bool {
        return value is T
    }
    
    func getPropertyType() -> String {
        return "\(T.self)"
    }
}

extension Parser where T == [String: Any] {

    func parse(_ value: Any) -> T {
        return value as! T
    }
    
    func getPropertyType(name: String) -> String {
        return "\(name)"
    }
}

extension Parser where T == [Any] {
    
    func parse(_ value: Any) -> T {
        return value as! T
    }
    
    func getPropertyType(name: String, value: T, json2Codable: Json2Codable) -> String {
        guard let item = value.first else {
            return "[Any]"
        }
        
        let intParser = Parser<Int>()
        let stringParser = Parser<String>()
        let doubleParser = Parser<Double>()
        let dictionaryParser = Parser<[String: Any]>()
        
        var propertyType: String = "Any"
        
        if intParser.canParse(item) {
            propertyType = "Int"
        } else if doubleParser.canParse(item) {
            propertyType = "Double"
        } else if stringParser.canParse(item) {
            propertyType = "String"
        } else if dictionaryParser.canParse(item) {
            propertyType = name
            json2Codable.convertToCodable(name: name, from: dictionaryParser.parse(item))
        } else if canParse(item) {
            propertyType = "\(getPropertyType(name: name, value: parse(item), json2Codable: json2Codable))"
        }
        
        return "[\(propertyType)]"
    }
}

class Json2Codable {
    
    private let intParser = Parser<Int>()
    private let stringParser = Parser<String>()
    private let doubleParser = Parser<Double>()
    private let dictionaryParser = Parser<[String: Any]>()
    private let arrayParser = Parser<[Any]>()
    
    private var classes: [String: [(String, String)]] = [:]
    
    func convertToCodable(name: String, from dictionary: [String: Any]) {
        classes[name] = []
        
        dictionary.keys.forEach { key in
            let jsonValue = dictionary[key]!
            var property: String = ""
            
            if intParser.canParse(jsonValue) {
                property = intParser.getPropertyType()
            } else if doubleParser.canParse(jsonValue) {
                property = doubleParser.getPropertyType()
            } else if stringParser.canParse(jsonValue) {
                property = stringParser.getPropertyType()
            } else if dictionaryParser.canParse(jsonValue){
                property = dictionaryParser.getPropertyType(name: key)
                convertToCodable(name: key, from: dictionaryParser.parse(jsonValue))
            } else if arrayParser.canParse(jsonValue) {
                property = arrayParser.getPropertyType(name: key, value: arrayParser.parse(jsonValue), json2Codable: self)
            }
            
            classes[name]?.append((key, property))
        }
    }
    
    func printClasses() {
        for entry in classes {
            print("class \(entry.key.camelCasedString.singular): Codable {\n")
            entry.value.forEach{ print("\t var \($0.0.camelCasedString.lowercaseFirstLetter()): \($0.1.camelCasedString.singular)!") }
            print("}\n")
        }
    }
}

do {
    let personStr = "{\n  \"greeting\": \"Welcome to quicktype!\",\n  \"instructions\": {\n     \"tests\": [\n        {\"name\": \"Type or paste JSON here\"},\n        {\"name\": \"Or choose a sample above\"},\n        {\"name\": \"quicktype will generate code in your\"},\n        {\"name\": \"chosen language to parse the sample data\"}\n    ]\n  }\n}"
    let data = personStr.data(using: .utf8)!
    let dictionary = try JSONSerialization.jsonObject(with: data) as! [String: Any]
    let converter = Json2Codable()
    converter.convertToCodable(name: "person", from: dictionary)
    converter.printClasses()
} catch {

}


