//
//  NFXListController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 8.0, *)
class NFXListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate
{
    // MARK: Properties
    
    var tableView: UITableView = UITableView()
    
    var tableData = [NFXHTTPModel]()
    var filteredTableData = [NFXHTTPModel]()
    
    var searchController: UISearchController!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.frame = self.view.frame
        self.tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.tableView.translatesAutoresizingMaskIntoConstraints = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        self.tableView.registerClass(StockCell.self, forCellReuseIdentifier: NSStringFromClass(StockCell))
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        self.navigationItem.titleView = searchController.searchBar
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "reloadTableData",
            name: "NFXReloadTableData",
            object: nil)
        
        
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        let predicateURL = NSPredicate(format: "requestURL contains[cd] '\(searchController.searchBar.text!)'")
        let predicateMethod = NSPredicate(format: "requestMethod contains[cd] '\(searchController.searchBar.text!)'")
        let predicateType = NSPredicate(format: "responseType contains[cd] '\(searchController.searchBar.text!)'")

        let predicates = [predicateURL, predicateMethod, predicateType]
        
        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (NFXHTTPModelManager.sharedInstance.models as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredTableData = array as! [NFXHTTPModel]
        reloadTableData()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.searchController.active) {
            return self.filteredTableData.count
        } else {
            return NFXHTTPModelManager.sharedInstance.models.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier( NSStringFromClass(StockCell), forIndexPath: indexPath) as! StockCell
        
        if (self.searchController.active) {
            let obj = self.filteredTableData[indexPath.row]
            cell.configForObject(obj)
        } else {
            let obj = NFXHTTPModelManager.sharedInstance.models[indexPath.row]
            cell.configForObject(obj)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return UIView.init(frame: CGRectZero)
    }
    
    func reloadTableData()
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var detailsController : NFXDetailsController
        detailsController = NFXDetailsController()
        detailsController.iIndex = indexPath.row
        self.navigationController?.pushViewController(detailsController, animated: true)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 58
    }

    
}