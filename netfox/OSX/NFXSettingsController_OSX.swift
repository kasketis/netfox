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
        tableData = HTTPModelShortType.allCases
        
        nfxVersionLabel.stringValue = nfxVersionString
        nfxURLButton.title = nfxURL

        let nibName = cellIdentifier

        responseTypesTableView.register(NSNib(nibNamed: nibName, bundle: nil),
                                        forIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier))
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.responseTypesTableView.reloadData()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        NFXHTTPModelManager.shared.filters = filters
    }
    
    // MARK: Actions

    @IBAction func loggingButtonClicked(sender: NSButton) {
        if sender.state == .on {
            NFX.sharedInstance().enable()
        } else {
            NFX.sharedInstance().disable()
        }
    }
    
    @IBAction func clearDataClicked(sender: AnyObject?) {
        NFX.sharedInstance().clearOldData()
    }
    
    @IBAction func nfxURLButtonClicked(sender: NSButton) {
        NSWorkspace.shared.open(URL(string: nfxURL)!)
    }
    
    @IBAction func toggleResponseTypeClicked(sender: NSButton) {
        filters[sender.tag] = !filters[sender.tag]
        NFXHTTPModelManager.shared.filters = filters
    }
    
    // MARK: Table View Delegate and DataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil)
        guard let cell = cellView as? NFXResponseTypeCell_OSX else {
            return nil
        }
        
        let shortType = tableData[row]
        cell.typeLabel.stringValue = shortType.rawValue
        cell.activeCheckbox.state = filters[row] ? .on : .off
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
