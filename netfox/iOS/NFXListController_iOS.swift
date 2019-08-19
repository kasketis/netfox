//
//  NFXListController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)
    
import Foundation
import UIKit

class NFXListController_iOS: NFXListController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate, DataCleaner {
    // MARK: Properties
    
    var tableView: UITableView = UITableView()
    var searchController: UISearchController!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge.all
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
        tableView.frame = self.view.frame
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(self.tableView)
        tableView.register(NFXListCell.self, forCellReuseIdentifier: NSStringFromClass(NFXListCell.self))

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.NFXClose(), style: .plain, target: self, action: #selector(NFXListController_iOS.closeButtonPressed))

        let rightButtons = [
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(NFXListController_iOS.trashButtonPressed)),
            UIBarButtonItem(image: UIImage.NFXSettings(), style: .plain, target: self, action: #selector(NFXListController_iOS.settingsButtonPressed))
        ]

        self.navigationItem.rightBarButtonItems = rightButtons


        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.barTintColor = UIColor.NFXOrangeColor()
        searchController.searchBar.tintColor = UIColor.NFXOrangeColor()
        searchController.searchBar.searchBarStyle = .minimal
        searchController.view.backgroundColor = UIColor.clear
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            definesPresentationContext = true
        } else {
            let searchView = UIView()
            searchView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 60, height: 0)
            searchView.autoresizingMask = [.flexibleWidth]
            searchView.autoresizesSubviews = true
            searchView.backgroundColor = UIColor.clear
            searchView.addSubview(searchController.searchBar)
            searchController.searchBar.sizeToFit()
            searchView.frame = searchController.searchBar.frame

            navigationItem.titleView = searchView
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NFXListController.reloadTableViewData),
            name: NSNotification.Name.NFXReloadData,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NFXListController_iOS.deactivateSearchController),
            name: NSNotification.Name.NFXDeactivateSearch,
            object: nil)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableViewData()
    }
    
    override func reloadTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        }
    }
    
    @objc func settingsButtonPressed() {
        var settingsController: NFXSettingsController_iOS
        settingsController = NFXSettingsController_iOS()
        navigationController?.pushViewController(settingsController, animated: true)
    }

    @objc func trashButtonPressed() {
        clearData(sourceView: tableView, originingIn: nil) {
            self.reloadTableViewData()
        }
    }

    @objc func closeButtonPressed() {
        NFX.sharedInstance().hide()
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        updateSearchResultsForSearchControllerWithString(searchController.searchBar.text!)
        reloadTableViewData()
    }
    
    @objc func deactivateSearchController() {
        searchController.isActive = false
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredTableData.count
        } else {
            return NFXHTTPModelManager.sharedInstance.getModels().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NFXListCell.self), for: indexPath) as! NFXListCell
        
        if searchController.isActive {
            if !filteredTableData.isEmpty {
                let obj = filteredTableData[(indexPath as NSIndexPath).row]
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var detailsController : NFXDetailsController_iOS
        detailsController = NFXDetailsController_iOS()
        var model: NFXHTTPModel
        if searchController.isActive {
            model = filteredTableData[(indexPath as NSIndexPath).row]
        } else {
            model = NFXHTTPModelManager.sharedInstance.getModels()[(indexPath as NSIndexPath).row]
        }
        detailsController.selectedModel(model)
        navigationController?.pushViewController(detailsController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
}

#endif
