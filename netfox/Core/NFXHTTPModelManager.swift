//
//  NFXHTTPModelManager.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

private let _sharedInstance = NFXHTTPModelManager()

final class NFXHTTPModelManager: NSObject
{
    static let sharedInstance = NFXHTTPModelManager()
    private var models = [NFXHTTPModel]()
    
    func add(obj: NFXHTTPModel)
    {
        self.models.insert(obj, atIndex: 0)
    }
    
    func clear()
    {
        self.models.removeAll()
    }
    
    func getModels() -> [NFXHTTPModel]
    {        
        var predicates = [NSPredicate]()
        
        let filterValues = NFX.sharedInstance().getCachedFilters()
        let filterNames = HTTPModelShortType.allValues
        
        var index = 0
        for filterValue in filterValues {
            if filterValue {
                let filterName = filterNames[index].rawValue
                let predicate = NSPredicate(format: "shortType == '\(filterName)'")
                predicates.append(predicate)

            }
            index += 1
        }

        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (self.models as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        return array as! [NFXHTTPModel]
    }
}
