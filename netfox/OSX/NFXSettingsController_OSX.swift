//
//  NFXSettingsController_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
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

        #if swift(>=4.2)
        let nibName = cellIdentifier
        #else
        let nibName = NSNib.Name(rawValue: cellIdentifier)
        #endif

        responseTypesTableView.register(NSNib(nibNamed: nibName, bundle: nil),
                                        forIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier))
        
        reloadTableData()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        NFX.sharedInstance().cacheFilters(filters)
    }
    
    // MARK: Actions

    @IBAction func loggingButtonClicked(sender: NSButton) {
        var senderStateOn: Bool
        #if !swift(>=4.0)
            senderStateOn = sender.state == NSControlStateValueOn
        #else
            senderStateOn = sender.state == .on
        #endif
        
        if senderStateOn {
            NFX.sharedInstance().enable()
        } else {
            NFX.sharedInstance().disable()
        }
    }
    
    @IBAction func clearDataClicked(sender: AnyObject?) {
        NFX.sharedInstance().clearOldData()
        NotificationCenter.default.post(name: NSNotification.Name.NFXReloadData, object: nil)
    }
    
    @IBAction func nfxURLButtonClicked(sender: NSButton) {
        NSWorkspace.shared.open(URL(string: nfxURL)!)
    }
    
    @IBAction func toggleResponseTypeClicked(sender: NSButton) {
        filters[sender.tag] = !filters[sender.tag]
        NFX.sharedInstance().cacheFilters(filters)
        NotificationCenter.default.post(name: NSNotification.Name.NFXReloadData, object: nil)
    }
    
    func reloadTableData() {
        DispatchQueue.main.async {
            self.responseTypesTableView.reloadData()
        }
    }
    
    // MARK: Table View Delegate and DataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        #if !swift(>=4.0)
            guard let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NFXResponseTypeCell_OSX else {
                return nil
            }
        #else
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NFXResponseTypeCell_OSX else {
            return nil
            }
        #endif
        
        let shortType = tableData[row]
        cell.typeLabel.stringValue = shortType.rawValue
        #if !swift(>=4.0)
            cell.activeCheckbox.state = filters[row] ? NSControlStateValueOn : NSControlStateValueOff
        #else
            cell.activeCheckbox.state = filters[row] ? .on : .off
        #endif
        cell.activeCheckbox.tag = row
        cell.activeCheckbox.target = self
        cell.activeCheckbox.action = #selector(toggleResponseTypeClicked(sender:))
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow: Int) -> Bool {
        return false
    }
    
}

#endif
