//
//  NFXListController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)
    
import Foundation
import UIKit

@available(iOS 8.0, *)
class NFXListController_iOS: NFXListController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate
{
    // MARK: Properties
    
    var tableView: UITableView = UITableView()
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.NFXSettings(), style: .Plain, target: self, action: #selector(NFXListController_iOS.settingsButtonPressed))

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
            selector: #selector(NFXListController.reloadTableViewData),
            name: "NFXReloadData",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(NFXListController_iOS.deactivateSearchController),
            name: "NFXDeactivateSearch",
            object: nil)        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        reloadTableViewData()
    }
    
    func settingsButtonPressed()
    {
        var settingsController: NFXSettingsController_iOS
        settingsController = NFXSettingsController_iOS()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.updateSearchResultsForSearchControllerWithString(searchController.searchBar.text!)
        reloadTableViewData()
    }
    
    func deactivateSearchController()
    {
        self.searchController.active = false
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(NFXListCell), forIndexPath: indexPath) as! NFXListCell
        
        if (self.searchController.active) {
            if self.filteredTableData.count > 0 {
                let obj = self.filteredTableData[indexPath.row]
                cell.configForObject(obj)
            }
        } else {
            if NFXHTTPModelManager.sharedInstance.getModels().count > 0 {
                let obj = NFXHTTPModelManager.sharedInstance.getModels()[indexPath.row]
                cell.configForObject(obj)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return UIView.init(frame: CGRectZero)
    }
    
    override func reloadTableViewData()
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
        var detailsController : NFXDetailsController_iOS
        detailsController = NFXDetailsController_iOS()
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

#endif
