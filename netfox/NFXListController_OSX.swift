//
//  NFXListController_OSX.swift
//  NetfoxForMac
//
//  Created by Tom Baranes on 12/01/16.
//  Copyright © 2016 Netfox. All rights reserved.
//

#if os(OSX)

import Cocoa
    
class TestView: NSView {
    override func drawRect(dirtyRect: NSRect) {
        NSRectFill(dirtyRect)
    }
}

class NFXListController_OSX: NFXListController, NSTableViewDelegate, NSTableViewDataSource, NSSearchFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet var searchField: NSSearchField!
    @IBOutlet var tableView: NSTableView!

    var isSearchControllerActive: Bool = false
    var delegate: NFXWindowControllerDelegate?
    
    private let cellIdentifier = "NFXListCell_OSX"
    
    // MARK: View Life Cycle

    override func awakeFromNib() {
        tableView.registerNib(NSNib(nibNamed: cellIdentifier, bundle: nil), forIdentifier: cellIdentifier)
    }

    override func loadView() {}

    override func reloadData()
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
    }
    
    // MARK: Notifications
    
    func deactivateSearchController()
    {
        self.isSearchControllerActive = false
    }
    
    // MARK: Search
    
    func updateSearchResultsForSearchController()
    {
//        let predicateURL = NSPredicate(format: "requestURL contains[cd] '\(self.saearchField.stringValue!)'")
//        let predicateMethod = NSPredicate(format: "requestMethod contains[cd] '\(self.saearchField.stringValue!)'")
//        let predicateType = NSPredicate(format: "responseType contains[cd] '\(self.saearchField.stringValue!)'")
//        
//        let predicates = [predicateURL, predicateMethod, predicateType]
//        
//        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
//        
//        let array = (NFXHTTPModelManager.sharedInstance.getModels() as NSArray).filteredArrayUsingPredicate(searchPredicate)
//        self.filteredTableData = array as! [NFXHTTPModel]
        reloadData()
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