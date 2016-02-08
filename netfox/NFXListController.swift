//
//  NFXListController.swift
//  NetfoxForMac
//
//  Created by Tom Baranes on 12/01/16.
//  Copyright © 2016 Netfox. All rights reserved.
//

class NFXListController: NFXGenericController {

    var tableData = [NFXHTTPModel]()
    var filteredTableData = [NFXHTTPModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "reloadTableViewData",
            name: "NFXReloadData",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "deactivateSearchController",
            name: "NFXDeactivateSearch",
            object: nil)
    }
    
}
