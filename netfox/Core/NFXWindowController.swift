//
//  NFXWindowController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa

protocol NFXWindowControllerDelegate {
    func httpModelSelectedDidChange(model: NFXHTTPModel)
}
    
class NFXWindowController: NSWindowController, NSWindowDelegate, NFXWindowControllerDelegate {
    
    @IBOutlet var settingsButton: NSButton!
    @IBOutlet var infoButton: NSButton!
    @IBOutlet var statisticsButton: NSButton!

    @IBOutlet var popupButton: NSPopUpButton!
    @IBOutlet var listView: NSView!
    @IBOutlet var detailsView: NSView!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var listViewController: NFXPathNodeListController_OSX!
    @IBOutlet var structuredListViewController: NFXPathNodeListController_OSX!
    @IBOutlet var detailsViewController: NFXDetailsController_OSX!
    
    @IBOutlet var settingsPopover: NSPopover!
    @IBOutlet var infoPopover: NSPopover!
    @IBOutlet var statisticsPopover: NSPopover!
    
    @IBOutlet var settingsViewController: NFXSettingsController_OSX!
    @IBOutlet var settingsView: NSView!

    @IBOutlet var infoViewController: NFXInfoController_OSX!
    @IBOutlet var infoView: NSView!
    @IBOutlet var segmentedControl: NSSegmentedControl!
    
    @IBOutlet var statisticsViewController: NFXStatisticsController_OSX!
    @IBOutlet var statisticsView: NSView!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        settingsButton.image = NSImage(data: NFXAssets.getImage(.settings))
        infoButton.image = NSImage(data: NFXAssets.getImage(.info))
        statisticsButton.image = NSImage(data: NFXAssets.getImage(.statistics))

        listViewController.delegate = self
        detailsViewController.view = detailsView
        
        structuredListViewController.delegate = self
        
        settingsViewController.view = settingsView
        infoViewController.view = infoView
        statisticsViewController.view = statisticsView

        listViewController.reloadData()
        statisticsViewController.reloadData()
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.delegate = self
        
        NFXNetService.shared.browseForAvailableNFXServices()
    }
    
    // MARK: NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? NSWindow , window == self.window {
            NFX.sharedInstance().windowDidClose()
        }
    }
    
    // MARK: Actions
    
    @IBAction func settingsClicked(_ sender: AnyObject?) {
        settingsPopover.show(relativeTo: NSZeroRect, of: settingsButton, preferredEdge: NSRectEdge.maxY)
    }
    
    @IBAction func infoClicked(_ sender: AnyObject?) {
        infoPopover.show(relativeTo: NSZeroRect, of: infoButton, preferredEdge: NSRectEdge.maxY)
    }
    
    @IBAction func statisticsClicked(_ sender: AnyObject?) {
        statisticsPopover.show(relativeTo: NSZeroRect, of: statisticsButton, preferredEdge: NSRectEdge.maxY)
    }
    
    @IBAction func hostClicked(_ sender: Any) {
        let (service, address) =  NFXNetService.shared.foundServices[popupButton.indexOfSelectedItem]
        NFXNetService.shared.fetchServiceContent(service: service)
    }
    
    @IBAction func segmentedAction(_ sender: Any) {
        switch segmentedControl.selectedSegment {
        case 0:
            listViewController.searchField.delegate = listViewController
            listViewController.tableView = tableView
            tableView.delegate = listViewController
            tableView.dataSource = listViewController
            tableView.reloadData()
        case 1:
            structuredListViewController.searchField.delegate = structuredListViewController
            structuredListViewController.tableView = tableView
            tableView.delegate = structuredListViewController
            tableView.dataSource = structuredListViewController
            tableView.reloadData()
        default:
            abort()
        }
    }
    
}
    
extension NFXWindowController {
    func httpModelSelectedDidChange(model: NFXHTTPModel) {
        self.detailsViewController.selectedModel(model)
    }
}

#endif
