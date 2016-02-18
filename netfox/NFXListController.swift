//
//  NFXListController.swift
//  NetfoxForMac
//
//  Created by Tom Baranes on 12/01/16.
//  Copyright © 2016 Netfox. All rights reserved.
//

import Foundation

class NFXListController: NFXGenericController {

    var tableData = [NFXHTTPModel]()
    var filteredTableData = [NFXHTTPModel]()

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    
    func updateSearchResultsForSearchControllerWithString(searchString: String)
    {
        let predicateURL = NSPredicate(format: "requestURL contains[cd] '\(searchString)'")
        let predicateMethod = NSPredicate(format: "requestMethod contains[cd] '\(searchString)'")
        let predicateType = NSPredicate(format: "responseType contains[cd] '\(searchString)'")
        let predicates = [predicateURL, predicateMethod, predicateType]
        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (NFXHTTPModelManager.sharedInstance.getModels() as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredTableData = array as! [NFXHTTPModel]
    }

    func reloadTableViewData()
    {
    }
    
}
