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
    
    // MARK: View Life Cycle
    
    override func awakeFromNib() {
        let bundle = Bundle(for: type(of: self))
        if Bundle.main.bundleIdentifier == "com.tapptitude.netfox-mac" {
            #if !swift(>=4.0)
                tableView.register(NSNib(nibNamed: cellIdentifier, bundle: bundle), forIdentifier: cellIdentifier)
            #else
                tableView.register(NSNib(nibNamed: NSNib.Name(rawValue: cellIdentifier), bundle: bundle), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier))
            #endif
        }
        searchField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(NFXListController.reloadTableViewData), name: .NFXReloadData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NFXPathNodeListController_OSX.deactivateSearchController), name: .NFXDeactivateSearch, object: nil)
        
        pathNodeTableData = modelManager.getTableModels()
    }
    
    // MARK: Notifications
    
    override func reloadTableViewData() {
        DispatchQueue.main.async {
            if self.searchField.stringValue.isEmpty {
                self.pathNodeTableData = self.modelManager.getTableModels()
            } else {
                let filtered = self.filter(models: self.modelManager.getHttpModels(), searchString: self.searchField.stringValue)
                let model = NFXPathNodeManager()
                model.add(filtered)
                self.pathNodeTableData = model.getTableModels()
            }
            
            self.tableView.reloadData()
        }
    }
    
    @objc func deactivateSearchController() {
        isSearchControllerActive = false
    }
    
    // MARK: Search
    
    func filter(models: [NFXHTTPModel], searchString: String) -> [NFXHTTPModel] {
        let predicateURL = NSPredicate(format: "requestURL contains[cd] '\(searchString)'")
        let predicateMethod = NSPredicate(format: "requestMethod contains[cd] '\(searchString)'")
        let predicateType = NSPredicate(format: "responseType contains[cd] '\(searchString)'")
        let predicates = [predicateURL, predicateMethod, predicateType]
        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (models as NSArray).filtered(using: searchPredicate)
        return array as! [NFXHTTPModel]
    }
    
    func updateSearchResultsForSearchController() {
        updateSearchResultsForSearchControllerWithString(searchField.stringValue)
        reloadTableViewData()
    }
    
    @objc override func controlTextDidChange(_ obj: Notification) {
        guard let searchField = obj.object as? NSSearchField else {
            return
        }
        
        isSearchControllerActive = searchField.stringValue.count > 0
        updateSearchResultsForSearchController()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pathNodeTableData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        #if !swift(>=4.0)
            guard let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NFXPathNodeListCell_OSX else {
                return nil
            }        #else
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NFXPathNodeListCell_OSX else {
            return nil
            }        #endif
        
        let obj = pathNodeTableData[row]
        cell.configForObject(obj: obj)
        
        return cell
    }
    
    // MARK: NSTableViewDelegate
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 20
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow >= 0 else {
            return
        }
        
        if let httpModel = pathNodeTableData[tableView.selectedRow].httpModel {
            delegate?.httpModelSelectedDidChange(model: httpModel)
        } else {
            let node = pathNodeTableData[tableView.selectedRow]
            if !node.isExpanded {
                node.isExpanded = true
                pathNodeTableData.insert(contentsOf: node.children, at: tableView.selectedRow + 1)
                reloadTableViewData()
            } else {
                node.isExpanded = false
                reloadTableViewData()
            }
        }
    }
}
    
#endif

