//
//  NFXSettingsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

class NFXSettingsController: NFXGenericController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: Properties

    var nfxURL = "https://github.com/kasketis/netfox"
    
    var tableView: UITableView = UITableView()
    
    var tableData = [HTTPModelShortType]()
    var filters = [Bool]()

    // MARK: View Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Settings"
                
        self.tableData = HTTPModelShortType.allValues
        self.filters =  NFX.sharedInstance().getCachedFilters()
        
        self.edgesForExtendedLayout = .None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        var filtersInfoLabel: UILabel
        filtersInfoLabel = UILabel(frame: CGRectMake(10, 20, CGRectGetWidth(self.view.frame) - 2*10, 30))
        filtersInfoLabel.font = UIFont.NFXFont(12)
        filtersInfoLabel.textColor = UIColor.NFXGray44Color()
        filtersInfoLabel.textAlignment = .Center
        filtersInfoLabel.text = "Select the types of responses that you want to see"
        filtersInfoLabel.numberOfLines = 0
        self.view.addSubview(filtersInfoLabel)
        
        self.tableView.frame = CGRectMake(0, 60, CGRectGetWidth(self.view.frame), CGFloat(self.tableData.count * 33))
        self.tableView.autoresizingMask = [.FlexibleWidth]
        self.tableView.translatesAutoresizingMaskIntoConstraints = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.scrollEnabled = false
        self.view.addSubview(self.tableView)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell))
        
        var nfxVersionLabel: UILabel
        nfxVersionLabel = UILabel(frame: CGRectMake(10, CGRectGetHeight(self.view.frame) - 60, CGRectGetWidth(self.view.frame) - 2*10, 30))
        nfxVersionLabel.autoresizingMask = [.FlexibleTopMargin]
        nfxVersionLabel.font = UIFont.NFXFont(14)
        nfxVersionLabel.textColor = UIColor.NFXOrangeColor()
        nfxVersionLabel.textAlignment = .Center
        nfxVersionLabel.text = "netfox - \(nfxVersion)"
        self.view.addSubview(nfxVersionLabel)
        
        var nfxURLButton: UIButton
        nfxURLButton = UIButton(frame: CGRectMake(10, CGRectGetHeight(self.view.frame) - 40, CGRectGetWidth(self.view.frame) - 2*10, 30))
        nfxURLButton.autoresizingMask = [.FlexibleTopMargin]
        nfxURLButton.titleLabel?.font = UIFont.NFXFont(12)
        nfxURLButton.setTitleColor(UIColor.NFXGray44Color(), forState: .Normal)
        nfxURLButton.titleLabel?.textAlignment = .Center
        nfxURLButton.setTitle(nfxURL, forState: .Normal)
        nfxURLButton.addTarget(self, action: Selector("nfxURLButtonPressed"), forControlEvents: .TouchUpInside)
        self.view.addSubview(nfxURLButton)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NFX.sharedInstance().cacheFilters(self.filters)
    }
    
    func nfxURLButtonPressed()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: nfxURL)!)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier( NSStringFromClass(UITableViewCell), forIndexPath: indexPath)
        
        let shortType = tableData[indexPath.row]
        cell.textLabel?.text = shortType.rawValue
        cell.textLabel?.font = UIFont.NFXFont(14)
        cell.tintColor = UIColor.NFXOrangeColor()
        configureCell(cell, indexPath: indexPath)
        
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
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.filters[indexPath.row] = !self.filters[indexPath.row]
        configureCell(cell, indexPath: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 33
    }
    
    func configureCell(cell: UITableViewCell?, indexPath: NSIndexPath)
    {
        if (cell != nil) {
            if self.filters[indexPath.row] {
                cell!.accessoryType = .Checkmark
            } else {
                cell!.accessoryType = .None
            }
        }

    }
    
    
}