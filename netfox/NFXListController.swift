//
//  NFXListController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit


@available(iOS 8.0, *)
class NFXListController: NFXGenericController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate
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
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.frame = self.view.frame
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.translatesAutoresizingMaskIntoConstraints = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        self.tableView.register(NFXListCell.self, forCellReuseIdentifier: NSStringFromClass(NFXListCell))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.NFXSettings(), style: .plain, target: self, action: #selector(NFXListController.settingsButtonPressed))

        let searchView = UIView()
        searchView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: 0)
        searchView.autoresizingMask = [.flexibleWidth]
        searchView.autoresizesSubviews = true
        searchView.backgroundColor = UIColor.clear
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        searchView.addSubview(self.searchController.searchBar)
        self.searchController.searchBar.autoresizingMask = [.flexibleWidth]
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.backgroundColor = UIColor.clear
        self.searchController.searchBar.searchBarStyle = .minimal
        searchView.frame = self.searchController.searchBar.frame
        self.searchController.view.backgroundColor = UIColor.clear
        
        self.navigationItem.titleView = searchView

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NFXGenericController.reloadData),
            name: NSNotification.Name(rawValue: "NFXReloadData"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NFXListController.deactivateSearchController),
            name: NSNotification.Name(rawValue: "NFXDeactivateSearch"),
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func settingsButtonPressed()
    {
        var settingsController: NFXSettingsController
        settingsController = NFXSettingsController()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let predicateURL = NSPredicate(format: "requestURL contains[cd] '\(searchController.searchBar.text!)'")
        let predicateMethod = NSPredicate(format: "requestMethod contains[cd] '\(searchController.searchBar.text!)'")
        let predicateType = NSPredicate(format: "responseType contains[cd] '\(searchController.searchBar.text!)'")

        let predicates = [predicateURL, predicateMethod, predicateType]
        
        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (NFXHTTPModelManager.sharedInstance.getModels() as NSArray).filtered(using: searchPredicate)
        self.filteredTableData = array as! [NFXHTTPModel]
        reloadData()
    }
    
    func deactivateSearchController()
    {
        self.searchController.isActive = false
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.searchController.isActive) {
            return self.filteredTableData.count
        } else {
            return NFXHTTPModelManager.sharedInstance.getModels().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NFXListCell), for: indexPath) as! NFXListCell
        
        if (self.searchController.isActive) {
            if self.filteredTableData.count > 0 {
                let obj = self.filteredTableData[(indexPath as NSIndexPath).row]
                cell.configForObject(obj)
            }
        } else {
            if NFXHTTPModelManager.sharedInstance.getModels().count > 0 {
                let obj = NFXHTTPModelManager.sharedInstance.getModels()[(indexPath as NSIndexPath).row]
                cell.configForObject(obj)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return UIView.init(frame: CGRect.zero)
    }
    
    override func reloadData()
    {
        DispatchQueue.main.async { () -> Void in
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var detailsController : NFXDetailsController
        detailsController = NFXDetailsController()
        var model: NFXHTTPModel
        if (self.searchController.isActive) {
            model = self.filteredTableData[(indexPath as NSIndexPath).row]
        } else {
            model = NFXHTTPModelManager.sharedInstance.getModels()[(indexPath as NSIndexPath).row]
        }
        detailsController.selectedModel(model)
        self.navigationController?.pushViewController(detailsController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 58
    }

    


}
