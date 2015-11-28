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
        
        self.tableView.registerClass(NFXListCell.self, forCellReuseIdentifier: NSStringFromClass(NFXListCell))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.NFXSettings(), style: .Plain, target: self, action: Selector("settingsButtonPressed"))

        let searchView = UIView()
        searchView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 60, 0)
        searchView.autoresizingMask = [.FlexibleWidth]
        searchView.autoresizesSubviews = true
        searchView.backgroundColor = UIColor.clearColor()
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        searchView.addSubview(self.searchController.searchBar)
        self.searchController.searchBar.autoresizingMask = [.FlexibleWidth]
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.backgroundColor = UIColor.clearColor()
        self.searchController.searchBar.searchBarStyle = .Minimal
        searchView.frame = self.searchController.searchBar.frame
        self.searchController.view.backgroundColor = UIColor.clearColor()
        
        self.navigationItem.titleView = searchView

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "reloadTableData",
            name: "NFXReloadTableData",
            object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableData()
    }
    
    func settingsButtonPressed()
    {
        var settingsController: NFXSettingsController
        settingsController = NFXSettingsController()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        let predicateURL = NSPredicate(format: "requestURL contains[cd] '\(searchController.searchBar.text!)'")
        let predicateMethod = NSPredicate(format: "requestMethod contains[cd] '\(searchController.searchBar.text!)'")
        let predicateType = NSPredicate(format: "responseType contains[cd] '\(searchController.searchBar.text!)'")

        let predicates = [predicateURL, predicateMethod, predicateType]
        
        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (NFXHTTPModelManager.sharedInstance.getModels() as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredTableData = array as! [NFXHTTPModel]
        reloadTableData()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.searchController.active) {
            return self.filteredTableData.count
        } else {
            return NFXHTTPModelManager.sharedInstance.getModels().count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier( NSStringFromClass(NFXListCell), forIndexPath: indexPath) as! NFXListCell
        
        if (self.searchController.active) {
            let obj = self.filteredTableData[indexPath.row]
            cell.configForObject(obj)
        } else {
            let obj = NFXHTTPModelManager.sharedInstance.getModels()[indexPath.row]
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
        var model: NFXHTTPModel
        if (self.searchController.active) {
            model = self.filteredTableData[indexPath.row]
        } else {
            model = NFXHTTPModelManager.sharedInstance.getModels()[indexPath.row]
        }
        detailsController.selectedModel(model)
        self.navigationController?.pushViewController(detailsController, animated: true)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 58
    }

    
}