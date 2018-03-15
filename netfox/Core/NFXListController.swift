//
//  NFXListController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

class NFXListController: NFXGenericController {
    
    var tableData = [NFXHTTPModel]()
    var filteredTableData = [NFXHTTPModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    #if os(OSX)
    override func viewDidDisappear() {
        super.viewDidDisappear()
        NFX.sharedInstance().lastVisitDate = Date()
    }
    #elseif os(iOS)
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NFX.sharedInstance().lastVisitDate = Date()
    }
    #endif
    
    
    
    func updateSearchResultsForSearchControllerWithString(_ searchString: String)
    {
        let predicateURL = NSPredicate(format: "requestURL contains[cd] '\(searchString)'")
        let predicateMethod = NSPredicate(format: "requestMethod contains[cd] '\(searchString)'")
        let predicateType = NSPredicate(format: "responseType contains[cd] '\(searchString)'")
        let predicates = [predicateURL, predicateMethod, predicateType]
        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (NFXHTTPModelManager.sharedInstance.getModels() as NSArray).filtered(using: searchPredicate)
        self.filteredTableData = array as! [NFXHTTPModel]
    }
    
    @objc func reloadTableViewData()
    {
    }
    
}
