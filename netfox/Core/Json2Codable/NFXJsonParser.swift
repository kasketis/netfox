//
//  Parser.swift
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
    
    func getPropertyType() -> String {
        return "\(T.self)"
    }
}

extension NFXJsonParser where T == [String: Any] {
    
    func parse(_ value: Any) -> T {
        return value as! T
    }
    
    func getPropertyType(name: String) -> String {
        return "\(name)"
    }
}

extension NFXJsonParser where T == [Any] {
    
    func canParse(_ value: Any) -> Bool {
        return (value as? T)?.isEmpty == false
    }
    
    func parse(_ value: Any) -> T {
        return value as! T
    }
}
