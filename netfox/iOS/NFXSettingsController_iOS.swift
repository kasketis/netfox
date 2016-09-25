//
//  NFXSettingsController_iOS.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)
    
import UIKit

class NFXSettingsController_iOS: NFXSettingsController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    
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
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage.NFXStatistics(), style: .Plain, target: self, action: #selector(NFXSettingsController_iOS.statisticsButtonPressed)), UIBarButtonItem(image: UIImage.NFXInfo(), style: .Plain, target: self, action: #selector(NFXSettingsController_iOS.infoButtonPressed))]
        
        self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 60)
        self.tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.tableView.translatesAutoresizingMaskIntoConstraints = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alwaysBounceVertical = false
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView?.hidden = true
        self.view.addSubview(self.tableView)
        
        var nfxVersionLabel: UILabel
        nfxVersionLabel = UILabel(frame: CGRectMake(10, CGRectGetHeight(self.view.frame) - 60, CGRectGetWidth(self.view.frame) - 2*10, 30))
        nfxVersionLabel.autoresizingMask = [.FlexibleTopMargin, .FlexibleWidth]
        nfxVersionLabel.font = UIFont.NFXFont(14)
        nfxVersionLabel.textColor = UIColor.NFXOrangeColor()
        nfxVersionLabel.textAlignment = .Center
        nfxVersionLabel.text = nfxVersionString
        self.view.addSubview(nfxVersionLabel)
        
        var nfxURLButton: UIButton
        nfxURLButton = UIButton(frame: CGRectMake(10, CGRectGetHeight(self.view.frame) - 40, CGRectGetWidth(self.view.frame) - 2*10, 30))
        nfxURLButton.autoresizingMask = [.FlexibleTopMargin, .FlexibleWidth]
        nfxURLButton.titleLabel?.font = UIFont.NFXFont(12)
        nfxURLButton.setTitleColor(UIColor.NFXGray44Color(), forState: .Normal)
        nfxURLButton.titleLabel?.textAlignment = .Center
        nfxURLButton.setTitle(nfxURL, forState: .Normal)
        nfxURLButton.addTarget(self, action: #selector(NFXSettingsController_iOS.nfxURLButtonPressed), forControlEvents: .TouchUpInside)
        self.view.addSubview(nfxURLButton)
        
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        NFX.sharedInstance().cacheFilters(self.filters)
    }
    
    func nfxURLButtonPressed()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: nfxURL)!)
    }
    
    func infoButtonPressed()
    {
        var infoController: NFXInfoController_iOS
        infoController = NFXInfoController_iOS()
        self.navigationController?.pushViewController(infoController, animated: true)
    }
    
    func statisticsButtonPressed()
    {
        var statisticsController: NFXStatisticsController_iOS
        statisticsController = NFXStatisticsController_iOS()
        self.navigationController?.pushViewController(statisticsController, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0: return 1
        case 1: return self.tableData.count
        case 2: return 1
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont.NFXFont(14)
        cell.tintColor = UIColor.NFXOrangeColor()
        
        switch indexPath.section
        {
        case 0:
            cell.textLabel?.text = "Logging"
            let nfxEnabledSwitch: UISwitch
            nfxEnabledSwitch = UISwitch()
            nfxEnabledSwitch.setOn(NFX.sharedInstance().isEnabled(), animated: false)
            nfxEnabledSwitch.addTarget(self, action: #selector(NFXSettingsController_iOS.nfxEnabledSwitchValueChanged(_:)), forControlEvents: .ValueChanged)
            cell.accessoryView = nfxEnabledSwitch
            return cell
            
        case 1:
            let shortType = tableData[indexPath.row]
            cell.textLabel?.text = shortType.rawValue
            configureCell(cell, indexPath: indexPath)
            return cell
            
        case 2:
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.text = "Clear data"
            cell.textLabel?.textColor = UIColor.NFXRedColor()
            cell.textLabel?.font = UIFont.NFXFont(16)
            
            return cell
            
            
        default: return UITableViewCell()
            
        }
        
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
        return 3
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.NFXGray95Color()
        
        switch section {
        case 1:
            
            var filtersInfoLabel: UILabel
            filtersInfoLabel = UILabel(frame: headerView.bounds)
            filtersInfoLabel.backgroundColor = UIColor.clearColor()
            filtersInfoLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            filtersInfoLabel.font = UIFont.NFXFont(13)
            filtersInfoLabel.textColor = UIColor.NFXGray44Color()
            filtersInfoLabel.textAlignment = .Center
            filtersInfoLabel.text = "\nSelect the types of responses that you want to see"
            filtersInfoLabel.numberOfLines = 2
            headerView.addSubview(filtersInfoLabel)
            
            
        default: break
        }
        
        return headerView
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.section
        {
        case 1:
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            self.filters[indexPath.row] = !self.filters[indexPath.row]
            configureCell(cell, indexPath: indexPath)
            break
            
        case 2:
            clearDataButtonPressedOnTableIndex(indexPath)
            break
            
        default: break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        switch indexPath.section {
        case 0: return 44
        case 1: return 33
        case 2: return 44
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {        
        let iPhone4s = (UIScreen.mainScreen().bounds.height == 480)
        switch section {
        case 0:
            if iPhone4s {
                return 20
            } else {
                return 40
            }
        case 1:
            if iPhone4s {
                return 50
            } else {
                return 60
            }
        case 2:
            if iPhone4s {
                return 25
            } else {
                return 50
            }
        default: return 0
        }
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
    
    func nfxEnabledSwitchValueChanged(sender: UISwitch)
    {
        if sender.on {
            NFX.sharedInstance().enable()
        } else {
            NFX.sharedInstance().disable()
        }
    }
    
    func clearDataButtonPressedOnTableIndex(index: NSIndexPath)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "Clear data?", message: "", preferredStyle: .ActionSheet)
        actionSheetController.popoverPresentationController?.sourceView = tableView
        actionSheetController.popoverPresentationController?.sourceRect = tableView.rectForRowAtIndexPath(index)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            NFX.sharedInstance().clearOldData()
        }
        actionSheetController.addAction(yesAction)
        
        let noAction: UIAlertAction = UIAlertAction(title: "No", style: .Default) { action -> Void in
        }
        actionSheetController.addAction(noAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

}
    
#endif
