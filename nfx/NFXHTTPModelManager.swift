//
//  NFXHTTPModelManager.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation

private let _sharedInstance = NFXHTTPModelManager()

final class NFXHTTPModelManager: NSObject
{
    static let sharedInstance = NFXHTTPModelManager()
    var models = [NFXHTTPModel]()
    
    func add(obj: NFXHTTPModel)
    {
        self.models.insert(obj, atIndex: 0)
    }
}