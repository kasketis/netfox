//
//  NFXSettingsController_OSX.swift
//  KaraFun
//
//  Created by vince on 27/01/2016.
//  Copyright © 2016 Recisio. All rights reserved.
//

#if os(OSX)

import Cocoa
    
class NFXSettingsController_OSX: NFXSettingsController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet var responseTypesTableView: NSTableView!
    @IBOutlet var nfxVersionLabel: NSTextField!
    @IBOutlet var nfxURLButton: NSButton!
    
    private let cellIdentifier = "NFXResponseTypeCell_OSX"
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        self.tableData = HTTPModelShortType.allValues
        self.filters =  NFX.sharedInstance().getCachedFilters()
        
        nfxVersionLabel.stringValue = nfxVersionString
        nfxURLButton.title = nfxURL
        responseTypesTableView.registerNib(NSNib(nibNamed: cellIdentifier, bundle: nil), forIdentifier: cellIdentifier)
        
        reloadTableData()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        NFX.sharedInstance().cacheFilters(filters)
    }
    
    // MARK: Actions

    @IBAction func loggingButtonClicked(sender: NSButton) {
        if sender.state == NSOnState {
            NFX.sharedInstance().enable()
        } else {
            NFX.sharedInstance().disable()
        }
    }
    
    @IBAction func clearDataClicked(sender: AnyObject?) {
        NFX.sharedInstance().clearOldData()
    }
    
    @IBAction func nfxURLButtonClicked(sender: NSButton) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: nfxURL)!)
    }
    
    @IBAction func toggleResponseTypeClicked(sender: NSButton) {
        filters[sender.tag] = !filters[sender.tag]
    }
    
    func reloadTableData() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.responseTypesTableView.reloadData()
        }
    }
    
    // MARK: Table View Delegate and DataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NFXResponseTypeCell_OSX else {
            return nil
        }
        
        let shortType = tableData[row]
        cell.typeLabel.stringValue = shortType.rawValue
        cell.activeCheckbox.state = filters[row] ? NSOnState : NSOffState
        cell.activeCheckbox.tag = row
        cell.activeCheckbox.target = self
        cell.activeCheckbox.action = "toggleResponseTypeClicked:"

        return cell
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow: Int) -> Bool {
        return false
    }
    
}

#endif