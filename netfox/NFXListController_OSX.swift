//
//  NFXListController_OSX.swift
//  NetfoxForMac
//
//  Created by Tom Baranes on 12/01/16.
//  Copyright © 2016 Netfox. All rights reserved.
//

#if os(OSX)

import Cocoa

class NFXListController_OSX: NFXListController, NSTableViewDelegate, NSTableViewDataSource, NSSearchFieldDelegate {
    
    // MARK: Properties
    
    var searchField: NSSearchField!
    var tableView: NSTableView = NSTableView()
    var isSearchControllerActive: Bool = false
    var delegate: NFXWindowControllerDelegate?
    
    // MARK: View Life Cycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    func initializeWithFrame(frame: CGRect) {
        self.view.frame = frame
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        self.searchField = NSSearchField(frame: CGRectMake(0, NSHeight(frame) - 22.0, NSWidth(frame), 22.0))
        self.searchField.autoresizingMask = [.ViewWidthSizable]
        self.searchField.backgroundColor = NSColor.yellowColor()
        self.view.addSubview(self.searchField)
        
        self.tableView.frame = CGRectMake(0, NSHeight(self.searchField.frame), NSWidth(frame), NSHeight(frame) - NSHeight(self.searchField.frame))
        self.tableView.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        self.tableView.translatesAutoresizingMaskIntoConstraints = true
        self.tableView.setDelegate(self)
        self.tableView.setDataSource(self)
        self.tableView.layer?.backgroundColor = NSColor.greenColor().CGColor
        self.view.addSubview(self.tableView)
        self.tableView.registerNib(nil, forIdentifier: NSStringFromClass(NFXListCell_OSX))
    }
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func reloadData()
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
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
        
        let cell = tableView.makeViewWithIdentifier(NSStringFromClass(NFXListCell_OSX), owner: nil) as! NFXListCell_OSX
        
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