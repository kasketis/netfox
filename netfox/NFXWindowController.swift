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

    let listViewController = NFXListController_OSX()
    let detailsViewController = NFXListController_OSX()
    
    // MARK: Life cycle
    
    override init(window: NSWindow?) {
        super.init(window: window)
        self.window?.title = "netfox"
        self.window?.delegate = self
        self.setupSplitViewController()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup
    
    func setupSplitViewController() {
        let splitViewController = NSSplitViewController()
        splitViewController.view.frame = self.window!.frame
        splitViewController.addSplitViewItem(self.sidebarSplitViewItem())
        splitViewController.addSplitViewItem(self.bodySplitViewItem())
        splitViewController.splitView.layer?.backgroundColor = NFXColor.yellowColor().CGColor
        splitViewController.splitView.wantsLayer = true
        self.window?.contentViewController = splitViewController
    }
    
    func sidebarSplitViewItem() -> NSSplitViewItem {
        let windowWidth = NSWidth(self.window!.frame)
        listViewController.delegate = self
        listViewController.view.frame = CGRect(x: 0, y: 0, width: windowWidth / 3, height: NSHeight(self.window!.frame))
        let sidebarSplitViewItem = NSSplitViewItem(viewController: listViewController)
        return sidebarSplitViewItem
    }
    
    func bodySplitViewItem() -> NSSplitViewItem {
        let windowWidth = NSWidth(self.window!.frame)
        let sidebarWidth = windowWidth / 3
        detailsViewController.view.frame = CGRect(x: sidebarWidth, y: 0, width: windowWidth - sidebarWidth, height: NSHeight(self.window!.frame))
        let bodySplitViewItem = NSSplitViewItem(viewController: detailsViewController)
        return bodySplitViewItem
    }
    
    // MARK: NSWindowDelegate
    
    func windowWillClose(notification: NSNotification) {
        self.window?.delegate = nil
        NFX.sharedInstance().stop()
    }
}
    
extension NFXWindowController: NFXWindowControllerDelegate {
    func httpModelSelectedDidChange(model: NFXHTTPModel) {
        self.detailsViewController.selectedModel = model
    }
}

#endif