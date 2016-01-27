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
    @IBOutlet var infoButtons: NSButton!
    @IBOutlet var statisticsButton: NSButton!

    @IBOutlet var listView: NSView!
    @IBOutlet var detailsView: NSView!
    @IBOutlet var listViewController: NFXListController_OSX!
    @IBOutlet var detailsViewController: NFXDetailsController_OSX!
    
    @IBOutlet var settingsPopover: NSPopover!
    @IBOutlet var infoPopover: NSPopover!
    @IBOutlet var statisticsPopover: NSPopover!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        settingsButton.image = NSImage(data: NFXAssets.getImage(.INFO))
        infoButtons.image = NSImage(data: NFXAssets.getImage(.SETTINGS))
        statisticsButton.image = NSImage(data: NFXAssets.getImage(.STATISTICS))

        listViewController.view = listView
        detailsViewController.view = detailsView

        listViewController.reloadData()
    }

    // MARK: NSWindowDelegate
    
    func windowWillClose(notification: NSNotification) {
        self.window?.delegate = nil
        NFX.sharedInstance().stop()
    }
    
    // MARK: Actions
    
    @IBAction func settingsClicked(sender: AnyObject?) {
        print("settings")
        settingsPopover.showRelativeToRect(NSZeroRect, ofView: settingsButton, preferredEdge: NSRectEdge.MinY)
    }
    
    @IBAction func infoClicked(sender: AnyObject?) {
        print("info")
    }
    
    @IBAction func statisticsClicked(sender: AnyObject?) {
        print("statistics")
    }
}
    
extension NFXWindowController: NFXWindowControllerDelegate {
    func httpModelSelectedDidChange(model: NFXHTTPModel) {
        self.detailsViewController.selectedModel = model
    }
}

#endif