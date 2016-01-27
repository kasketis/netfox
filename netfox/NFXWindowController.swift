//
//  NFXWindowController.swift
//  NetfoxForMac
//
//  Created by Tom Baranes on 12/01/16.
//  Copyright © 2016 Netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa

protocol NFXWindowControllerDelegate {
    func httpModelSelectedDidChange(model: NFXHTTPModel)
}
    
class NFXWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet var settingsButton: NSButton!
    @IBOutlet var infoButton: NSButton!
    @IBOutlet var statisticsButton: NSButton!

    @IBOutlet var listView: NSView!
    @IBOutlet var detailsView: NSView!
    @IBOutlet var listViewController: NFXListController_OSX!
    @IBOutlet var detailsViewController: NFXDetailsController_OSX!
    
    @IBOutlet var settingsPopover: NSPopover!
    @IBOutlet var infoPopover: NSPopover!
    @IBOutlet var statisticsPopover: NSPopover!
    
    @IBOutlet var settingsViewController: NFXSettingsController_OSX!
    @IBOutlet var settingsView: NSView!

//    @IBOutlet var infoViewController: NFXInfoController_OSX!
//    @IBOutlet var infoView: NSView!
    
    @IBOutlet var statisticsViewController: NFXStatisticsController_OSX!
    @IBOutlet var statisticsView: NSView!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        settingsButton.image = NSImage(data: NFXAssets.getImage(.SETTINGS))
        infoButton.image = NSImage(data: NFXAssets.getImage(.INFO))
        statisticsButton.image = NSImage(data: NFXAssets.getImage(.STATISTICS))

        listViewController.view = listView
        detailsViewController.view = detailsView
        
        settingsViewController.view = settingsView
//        infoViewController.view = infoView
        statisticsViewController.view = statisticsView

        listViewController.reloadData()
    }

    // MARK: NSWindowDelegate
    
    func windowWillClose(notification: NSNotification) {
        self.window?.delegate = nil
        NFX.sharedInstance().stop()
    }
    
    // MARK: Actions
    
    @IBAction func settingsClicked(sender: AnyObject?) {
        settingsPopover.showRelativeToRect(NSZeroRect, ofView: settingsButton, preferredEdge: NSRectEdge.MinY)
    }
    
    @IBAction func infoClicked(sender: AnyObject?) {
        infoPopover.showRelativeToRect(NSZeroRect, ofView: infoButton, preferredEdge: NSRectEdge.MinY)
    }
    
    @IBAction func statisticsClicked(sender: AnyObject?) {
        statisticsPopover.showRelativeToRect(NSZeroRect, ofView: statisticsButton, preferredEdge: NSRectEdge.MinY)
    }
}
    
extension NFXWindowController: NFXWindowControllerDelegate {
    func httpModelSelectedDidChange(model: NFXHTTPModel) {
        self.detailsViewController.selectedModel = model
    }
}

#endif