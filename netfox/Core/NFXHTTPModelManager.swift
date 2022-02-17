//
//  NFXHTTPModelManager.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

private let _sharedInstance = NFXHTTPModelManager()

protocol NFXHTTPModelManagerDelegate: AnyObject {
    func nfxHTTPModelManager(_ manager: NFXHTTPModelManager, willAdd obj: NFXHTTPModel) -> NFXHTTPModel
}

final class NFXHTTPModelManager: NSObject {
    static let sharedInstance = NFXHTTPModelManager()
    fileprivate var models = [NFXHTTPModel]()
    private let syncQueue = DispatchQueue(label: "NFXSyncQueue")
    weak var delegate: NFXHTTPModelManagerDelegate?
    
    func add(_ obj: NFXHTTPModel) {
        syncQueue.async {
            self.models.insert(self.delegate?.nfxHTTPModelManager(self, willAdd: obj) ?? obj, at: 0)
            NotificationCenter.default.post(name: NSNotification.Name.NFXAddedModel, object: obj)
        }
    }
    
    func clear() {
        syncQueue.async {
            self.models.removeAll()
            NotificationCenter.default.post(name: NSNotification.Name.NFXClearedModels, object: nil)
        }
    }
    
    func getModels() -> [NFXHTTPModel] {
        var predicates = [NSPredicate]()
        
        let filterValues = NFX.sharedInstance().getCachedFilters()
        let filterNames = HTTPModelShortType.allValues
        
        for (index, filterValue) in filterValues.enumerated() {
            if filterValue {
                let filterName = filterNames[index].rawValue
                let predicate = NSPredicate(format: "shortType == '\(filterName)'")
                predicates.append(predicate)
            }
        }

        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        let array = (models as NSArray).filtered(using: searchPredicate)
        return array as! [NFXHTTPModel]
    }
}
