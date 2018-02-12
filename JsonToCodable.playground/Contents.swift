//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport




extension String {
    
    func uppercaseFirstLetter() -> String {
        let paranthesisCount = components(separatedBy: "]").count - 1
        let stringWithoutParanthesis = dropFirst(paranthesisCount)
        
        return String(repeating: "[", count: paranthesisCount) + stringWithoutParanthesis.capitalized
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



class CodableClass: CustomStringConvertible {
    
    var className: String
    var properties: [(String, String)] = []
    
    init(className: String) {
        self.className = className
    }
    
    func insertProperty(name: String, type: String) {
        properties.append((name, type))
    }
    
    var description: String {
        var str = "class \(className.camelCasedString.singular): Codable {\n\n"
        str += properties.map{ "\tvar \($0.0.camelCasedString.lowercaseFirstLetter()): \($0.1.camelCasedString.singular)" }.joined(separator: "\n")
        str += "\n\n\tenum CodingKeys: String, CodingKey {\n"
        str += properties.map{"\t\tcase \($0.0.camelCasedString.lowercaseFirstLetter()) = \"\($0.0)\""}.joined(separator: "\n")
        str += "\n\t}"
        str += "\n}\n\n"
        return str
    }
}



class Json2Codable {
    
    private let intParser = Parser<Int>()
    private let stringParser = Parser<String>()
    private let doubleParser = Parser<Double>()
    private let dictionaryParser = Parser<[String: Any]>()
    private let arrayParser = Parser<[Any]>()
    
    private var codableClasses: [CodableClass] = []
    
    func convertToCodable(name: String, from dictionary: [String: Any]) {
        let codableClass = CodableClass(className: name)
        codableClasses.append(codableClass)
        
        dictionary.keys.forEach { key in
            var property: String = ""
            
            if intParser.canParse(dictionary[key]!) {
                property = intParser.getPropertyType()
            } else if doubleParser.canParse(dictionary[key]!) {
                property = doubleParser.getPropertyType()
            } else if stringParser.canParse(dictionary[key]!) {
                property = stringParser.getPropertyType()
            } else if dictionaryParser.canParse(dictionary[key]!){
                property = dictionaryParser.getPropertyType(name: key)
                convertToCodable(name: key, from: dictionaryParser.parse(dictionary[key]!))
            } else if arrayParser.canParse(dictionary[key]!) {
                property = arrayParser.getPropertyType(name: key, value: arrayParser.parse(dictionary[key]!), json2Codable: self)
            }
            
            codableClass.insertProperty(name: key, type: property)
        }
    }
    
    func printClasses() {
        codableClasses.forEach{ print($0) }
    }
}




do {
    let personStr = "{\n  \"greeting_message\": \"Welcome to quicktype!\",\n  \"instructions\": {\n     \"tests\": [\n        {\"name\": \"Type or paste JSON here\"},\n        {\"name\": \"Or choose a sample above\"},\n        {\"name\": \"quicktype will generate code in your\"},\n        {\"name\": \"chosen language to parse the sample data\"}\n    ]\n  }\n}"
    let data = personStr.data(using: .utf8)!
    let dictionary = try JSONSerialization.jsonObject(with: data) as! [String: Any]
    let converter = Json2Codable()
    converter.convertToCodable(name: "person", from: dictionary)
    converter.printClasses()
} catch {

}


