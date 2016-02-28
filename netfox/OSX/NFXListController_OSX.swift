//
//  NFXListController_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)

import Cocoa

class NFXListController_OSX: NFXListController, NSTableViewDelegate, NSTableViewDataSource, NSSearchFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet var searchField: NSTextField!
    @IBOutlet var tableView: NSTableView!

    var isSearchControllerActive: Bool = false
    var delegate: NFXWindowControllerDelegate?
    
    private let cellIdentifier = "NFXListCell_OSX"
    
    // MARK: View Life Cycle

    override func awakeFromNib() {
        tableView.registerNib(NSNib(nibNamed: cellIdentifier, bundle: nil), forIdentifier: cellIdentifier)
        searchField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableViewData", name: "NFXReloadData", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deactivateSearchController", name: "NFXDeactivateSearch", object: nil)
    }
    
    // MARK: Notifications

    override func reloadTableViewData()
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
    }
    
    func deactivateSearchController()
    {
        self.isSearchControllerActive = false
    }
    
    // MARK: Search
    
    func updateSearchResultsForSearchController()
    {
        self.updateSearchResultsForSearchControllerWithString(searchField.stringValue)
        reloadTableViewData()
    }

    override func controlTextDidChange(obj: NSNotification) {
        guard let searchField = obj.object as? NSSearchField else {
            return
        }
        
        isSearchControllerActive = searchField.stringValue.characters.count > 0
        updateSearchResultsForSearchController()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if (self.isSearchControllerActive) {
            return self.filteredTableData.count
        } else {
            return NFXHTTPModelManager.sharedInstance.getModels().count
        }
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NFXListCell_OSX else {
            return nil
        }
        
        if (self.isSearchControllerActive) {
            if self.filteredTableData.count > 0 {
                let obj = self.filteredTableData[row]
                cell.configForObject(obj)
            }
        } else {
            if NFXHTTPModelManager.sharedInstance.getModels().count > 0 {
                let obj = NFXHTTPModelManager.sharedInstance.getModels()[row]
                cell.configForObject(obj)
            }
        }
        
        return cell
    }
    
    // MARK: NSTableViewDelegate

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 58
    }

    func tableViewSelectionDidChange(notification: NSNotification) {
        guard tableView.selectedRow >= 0 else {
            return
        }
        
        var model: NFXHTTPModel
        if (self.isSearchControllerActive) {
            model = self.filteredTableData[self.tableView.selectedRow]
        } else {
            model = NFXHTTPModelManager.sharedInstance.getModels()[self.tableView.selectedRow]
        }
        self.delegate?.httpModelSelectedDidChange(model)
    }
    
}

#endif