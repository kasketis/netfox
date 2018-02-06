//
//  NFXPathNodeListController_OSX.swift
//  netfox_osx
//
//  Created by Ștefan Suciu on 2/6/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

#if os(OSX)
    
import Cocoa

class NFXPathNodeListController_OSX: NFXListController, NSTableViewDelegate, NSTableViewDataSource, NSSearchFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet var searchField: NSTextField!
    @IBOutlet var tableView: NSTableView!
    
    var isSearchControllerActive: Bool = false
    var delegate: NFXWindowControllerDelegate?
    
    private let cellIdentifier = "NFXPathNodeListCell_OSX"
    
    fileprivate let modelManager = NFXPathNodeManager.sharedInstance
    fileprivate var pathNodeTableData: [NFXPathNode] = []
    fileprivate var pathNodeFilteredTableData: [NFXPathNode] = []
    
    // MARK: View Life Cycle
    
    override func awakeFromNib() {
        let bundle = Bundle(for: type(of: self))
        tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: cellIdentifier), bundle: bundle), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier))
        searchField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(NFXListController.reloadTableViewData), name: NSNotification.Name(rawValue: "NFXReloadData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NFXPathNodeListController_OSX.deactivateSearchController), name: NSNotification.Name(rawValue: "NFXDeactivateSearch"), object: nil)
        
        pathNodeTableData = modelManager.getModels()
    }
    
    // MARK: Notifications
    
    override func reloadTableViewData() {
        DispatchQueue.main.async {
            self.pathNodeTableData = self.modelManager.getTableModels()
            self.tableView.reloadData()
        }
    }
    
    @objc func deactivateSearchController() {
        isSearchControllerActive = false
    }
    
    // MARK: Search
    
    override func updateSearchResultsForSearchControllerWithString(_ searchString: String) {
        let predicateURL = NSPredicate(format: "requestURL contains[cd] '\(searchString)'")
        let predicateMethod = NSPredicate(format: "requestMethod contains[cd] '\(searchString)'")
        let predicateType = NSPredicate(format: "responseType contains[cd] '\(searchString)'")
        let predicates = [predicateURL, predicateMethod, predicateType]
        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (modelManager.getModels() as NSArray).filtered(using: searchPredicate)
        pathNodeFilteredTableData = array as! [NFXPathNode]
    }
    
    func updateSearchResultsForSearchController() {
        updateSearchResultsForSearchControllerWithString(searchField.stringValue)
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
        return isSearchControllerActive ? pathNodeFilteredTableData.count : pathNodeTableData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NFXPathNodeListCell_OSX else {
            return nil
        }
        
        if isSearchControllerActive && pathNodeFilteredTableData.count > 0 {
            let obj = pathNodeFilteredTableData[row]
            cell.configForObject(obj: obj)
        } else if !isSearchControllerActive && pathNodeTableData.count > 0 {
            let obj = pathNodeTableData[row]
            cell.configForObject(obj: obj)
        }
        
        return cell
    }
    
    // MARK: NSTableViewDelegate
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return pathNodeTableData[row].httpModel == nil ? 20 : 58
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow >= 0 else {
            return
        }
        
        if isSearchControllerActive {
            if let httpModel = pathNodeFilteredTableData[tableView.selectedRow].httpModel {
                delegate?.httpModelSelectedDidChange(model: httpModel)
            }
        } else {
            if let httpModel = pathNodeTableData[tableView.selectedRow].httpModel {
                delegate?.httpModelSelectedDidChange(model: httpModel)
            } else {
                let node = pathNodeTableData[tableView.selectedRow]
                if !node.isExpanded {
                    node.isExpanded = true
                    pathNodeTableData.insert(contentsOf: node.children, at: tableView.selectedRow + 1)
                    tableView.reloadData()
                } else {
                    node.isExpanded = false
                    reloadTableViewData()
                }
            }
        }
    }
}
    
#endif

