//
//  NFXJsonParser.swift
//  netfox_osx
//
//  Created by Ștefan Suciu on 2/13/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation


class NFXJsonParser<T> {
    
    func canParse(_ value: Any) -> Bool {
        return value is T
    }
    
    func parse(_ value: Any) -> T {
        return value as! T
    }
    
    func getPropertyType() -> String {
        return "\(T.self)"
    }
}

extension NFXJsonParser where T == [String: Any] {
    
    func getPropertyType(name: String) -> String {
        return "\(name)"
    }
}

extension NFXJsonParser where T == URL {
    
    func canParse(_ value: Any) -> Bool {
        let stringValue = value as! String
        return stringValue.hasPrefix("https://") || stringValue.hasPrefix("http://")
    }
}

extension NFXJsonParser where T == Date {
    
    private var keys: [String] {
        return ["_at", "date", "day"]
    }
    
    func canParse(_ value: String) -> Bool {
        let dateFormats = ["yyyy-MM-dd HH:mm:ss.ZZZZZ", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ssZZZZZZ"]
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = dateFormats.first!
        let accumulator = dateFormatter.date(from: value) != nil
        
        return dateFormats.dropFirst().map{
            dateFormatter.dateFormat = $0
            return dateFormatter.date(from: value) != nil
        }.reduce(accumulator, { $0 || $1 })
    }
    
    func canParse(key: String, value: Int) -> Bool {
        return keys.dropFirst().map{ key.contains($0) }.reduce(key.contains(keys.first!), { $0 || $1 })
    }
}

extension NFXJsonParser where T == Bool {
    
    func canParse(_ value: Any) -> Bool {
        return String(describing: type(of: value)).contains("Boolean")
    }
}
