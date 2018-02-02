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
        let bundle = Bundle(for: type(of: self))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: cellIdentifier), bundle: bundle), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier))
        searchField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(NFXListController.reloadTableViewData), name: NSNotification.Name(rawValue: "NFXReloadData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NFXListController_OSX.deactivateSearchController), name: NSNotification.Name(rawValue: "NFXDeactivateSearch"), object: nil)
    }
    
    // MARK: Notifications

    override func reloadTableViewData()
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func deactivateSearchController()
    {
        self.isSearchControllerActive = false
    }
    
    // MARK: Search
    
    func updateSearchResultsForSearchController()
    {
        self.updateSearchResultsForSearchControllerWithString(searchField.stringValue)
        reloadTableViewData()
    }

    func controlTextDidChange(obj: NSNotification) {
        guard let searchField = obj.object as? NSSearchField else {
            return
        }
        
        isSearchControllerActive = searchField.stringValue.count > 0
        updateSearchResultsForSearchController()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if (self.isSearchControllerActive) {
            return self.filteredTableData.count
        } else {
            return NFXHTTPModelManager.sharedInstance.getModels().count
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NFXListCell_OSX else {
            return nil
        }
        
        if (self.isSearchControllerActive) {
            if self.filteredTableData.count > 0 {
                let obj = self.filteredTableData[row]
                cell.configForObject(obj: obj)
            }
        } else {
            if NFXHTTPModelManager.sharedInstance.getModels().count > 0 {
                let obj = NFXHTTPModelManager.sharedInstance.getModels()[row]
                cell.configForObject(obj: obj)
            }
        }
        
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
        
        var model: NFXHTTPModel
        if (self.isSearchControllerActive) {
            model = self.filteredTableData[self.tableView.selectedRow]
        } else {
            model = NFXHTTPModelManager.sharedInstance.getModels()[self.tableView.selectedRow]
        }
        self.delegate?.httpModelSelectedDidChange(model: model)
    }
    
}

#endif
