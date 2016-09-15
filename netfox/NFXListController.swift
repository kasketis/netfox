//
//  NFXListController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 8.0, *)
class NFXListController: NFXGenericController, UITableViewDelegate,
    UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate
{
    // MARK: Properties
    
    var tableView: UITableView = UITableView()
    var refreshControl: UIRefreshControl!
    
    var tableData = [NFXHTTPModel]()
    var filteredTableData = [NFXHTTPModel]()
    
    var searchController: UISearchController!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.frame = self.view.frame
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.translatesAutoresizingMaskIntoConstraints = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.register(NFXListCell.self, forCellReuseIdentifier: NSStringFromClass(NFXListCell.self))
        
        self.refreshControl = UIRefreshControl();
        self.refreshControl.addTarget(self, action: #selector(NFXListController.reloadData), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        var settingImage = UIImage.NFXSettings()
        settingImage = settingImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingImage,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(NFXListController.settingsButtonPressed))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        
        var backImage = UIImage(named: "button_back")
        backImage = backImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(NFXListController.backButtonPressed))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        let searchView = UIView()
        searchView.frame = CGRect.init(x: 30, y: 0,
                                       width: self.view.frame.width - 60, height: 0)
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

        var notifName = NSNotification.Name(rawValue: "NFXReloadData")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NFXListController.reloadData),
            name:notifName,
            object: nil)
        
        notifName = NSNotification.Name(rawValue: "NFXDeactivateSearch")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NFXListController.deactivateSearchController),
            name: notifName,
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
    
    func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func doneButtonPressed()
    {
        NFX.sharedInstance().buttonHide()
    }

    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for: UISearchController)
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
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NFXListCell.self),
                                                      for: indexPath) as! NFXListCell
        
        if (self.searchController.isActive) {
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return UIView.init(frame: CGRect.zero)
    }
    
    override func reloadData()
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
            self.refreshControl.endRefreshing()
        }
//        dispatch_get_main_queue().asynch(group: DispatchQueue.main) { () -> Void in
//            self.tableView.reloadData()
//            self.tableView.setNeedsDisplay()
//            self.refreshControl.endRefreshing()
//        }
    }
    
    func numberOfSections(in: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var detailsController : NFXDetailsController
        detailsController = NFXDetailsController()
        var model: NFXHTTPModel
        if (self.searchController.isActive) {
            model = self.filteredTableData[indexPath.row]
        } else {
            model = NFXHTTPModelManager.sharedInstance.getModels()[indexPath.row]
        }
        detailsController.selectedModel(model)
        self.navigationController?.pushViewController(detailsController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 58
    }

}
