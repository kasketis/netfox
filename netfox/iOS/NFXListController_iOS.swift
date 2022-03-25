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
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    var searchController: UISearchController!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Requests"
        
        edgesForExtendedLayout = UIRectEdge.all
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
        tableView.frame = self.view.frame
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorInset = .zero
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    override func reloadData() {
        self.tableView.reloadData()
    }
    
    @objc func settingsButtonPressed() {
        var settingsController: NFXSettingsController_iOS
        settingsController = NFXSettingsController_iOS()
        navigationController?.pushViewController(settingsController, animated: true)
    }

    @objc func trashButtonPressed() {
        clearData(sourceView: tableView, originingIn: nil) { [weak self] in
            self?.reloadData()
        }
    }

    @objc func closeButtonPressed() {
        NFX.sharedInstance().hide()
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        filter = searchController.searchBar.text
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NFXListCell.self), for: indexPath) as! NFXListCell
        
        cell.configForObject(tableData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsController = NFXDetailsController_iOS()
        let model = tableData[indexPath.row]

        detailsController.selectedModel(model)

        navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
}

#endif

