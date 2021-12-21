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

    var delegate: NFXWindowControllerDelegate?
    
    private let cellIdentifier = "NFXListCell_OSX"
    
    // MARK: View Life Cycle

    override func awakeFromNib() {
        let nibName = cellIdentifier

        tableView.register(NSNib(nibNamed: nibName, bundle: nil),
                           forIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier))

        searchField.delegate = self
        
        reloadData()
    }
    
    // MARK: Notifications

    override func reloadData() {
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil)
        guard let cell = cellView as? NFXListCell_OSX else {
            return nil
        }
        
        cell.configForObject(obj: tableData[row])
        
        return cell
    }
    
    // MARK: NSTableViewDelegate

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 58
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow >= 0 else {
            return
        }
        
        delegate?.httpModelSelectedDidChange(model: tableData[tableView.selectedRow])
    }

    fileprivate func handleControlChange(obj: Notification) {
        guard let searchField = obj.object as? NSSearchField else {
            return
        }

        filter = searchField.stringValue
    }
}


extension NFXListController_OSX: NSControlTextEditingDelegate {
    func controlTextDidChange(_ obj: Notification) {
        handleControlChange(obj: obj)
    }
}

#endif

