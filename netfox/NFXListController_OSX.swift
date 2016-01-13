//
//  NFXListController_OSX.swift
//  NetfoxForMac
//
//  Created by Tom Baranes on 12/01/16.
//  Copyright © 2016 Netfox. All rights reserved.
//

#if os(OSX)

import Cocoa

class NFXListController_OSX: NFXListController, NSTableViewDelegate, NSTableViewDataSource {
    
    // MARK: Properties
    
    var tableView: NSTableView = NSTableView()
    var isSearchControllerActive: Bool = false
    var delegate: NFXWindowControllerDelegate?
    
    // MARK: View Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tableView.frame = self.view.frame
        self.tableView.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        self.tableView.translatesAutoresizingMaskIntoConstraints = true
        self.tableView.setDelegate(self)
        self.tableView.setDataSource(self)
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