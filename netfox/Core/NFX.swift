//
//  NFX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

let nfxVersion = "1.7.3"

@objc
public class NFX: NSObject
{
    #if os(OSX)
    var windowController: NFXWindowController?
    let mainMenu: NSMenu? = NSApp.mainMenu?.itemArray[1].submenu
    var nfxMenuItem: NSMenuItem = NSMenuItem(title: "netfox", action: "show", keyEquivalent: String(character: NSF9FunctionKey, length: 1))
    #endif
    
    // swiftSharedInstance is not accessible from ObjC
    class var swiftSharedInstance: NFX
    {
        struct Singleton
        {
            static let instance = NFX()
        }
        return Singleton.instance
    }
    
    // the sharedInstance class method can be reached from ObjC
    public class func sharedInstance() -> NFX
    {
        return NFX.swiftSharedInstance
    }
    
    @objc public enum ENFXGesture: Int
    {
        case shake
        case custom
    }
    
    private var started: Bool = false
    private var presented: Bool = false
    private var enabled: Bool = false
    private var selectedGesture: ENFXGesture = .shake
    private var ignoredURLs = [String]()
    private var filters = [Bool]()
    private var lastVisitDate: NSDate = NSDate()

    @objc public func start()
    {
        self.started = true
        register()
        enable()
        clearOldData()
        showMessage("Started!")
        #if os(OSX)
        self.addNetfoxToMainMenu()
        #endif
    }
    
    @objc public func stop()
    {
        unregister()
        disable()
        clearOldData()
        self.started = false
        showMessage("Stopped!")
        #if os(OSX)
        self.removeNetfoxFromMainmenu()
        #endif
    }
    
    private func showMessage(msg: String) {
        print("netfox \(nfxVersion) - [https://github.com/kasketis/netfox]: \(msg)")
    }
    
    internal func isEnabled() -> Bool
    {
        return self.enabled
    }
    
    internal func enable()
    {
        self.enabled = true
    }
    
    internal func disable()
    {
        self.enabled = false
    }
    
    private func register()
    {
        NSURLProtocol.registerClass(NFXProtocol)
    }
    
    private func unregister()
    {
        NSURLProtocol.unregisterClass(NFXProtocol)
    }
    
    func motionDetected()
    {
        if self.started {
            if self.presented {
                hideNFX()
            } else {
                showNFX()
            }
        }
    }
    
    @objc public func setGesture(gesture: ENFXGesture)
    {
        self.selectedGesture = gesture
        #if os(OSX)
            if gesture == .shake {
                self.addNetfoxToMainMenu()
            } else {
                self.removeNetfoxFromMainmenu()
            }
        #endif
    }
    
    @objc public func show()
    {
        if (self.started) && (self.selectedGesture == .custom) {
            showNFX()
        } else {
            print("netfox \(nfxVersion) - [ERROR]: Please call start() and setGesture(.custom) first")
        }
    }
    
    @objc public func hide()
    {
        if (self.started) && (self.selectedGesture == .custom) {
            hideNFX()
        } else {
            print("netfox \(nfxVersion) - [ERROR]: Please call start() and setGesture(.custom) first")
        }
    }
    
    @objc public func ignoreURL(url: String)
    {
        self.ignoredURLs.append(url)
    }
    
    internal func getLastVisitDate() -> NSDate
    {
        return self.lastVisitDate
    }
    
    private func showNFX()
    {
        if self.presented {
            return
        }
        
        self.showNFXFollowingPlatform()
        self.presented = true

    }
    
    private func hideNFX()
    {
        if !self.presented {
            return
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("NFXDeactivateSearch", object: nil)
        self.hideNFXFollowingPlatform { () -> Void in
            self.presented = false
            self.lastVisitDate = NSDate()
        }
    }
    
    internal func clearOldData()
    {
        NFXHTTPModelManager.sharedInstance.clear()
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first!
            let filePathsArray = try NSFileManager.defaultManager().subpathsOfDirectoryAtPath(documentsPath)
            for filePath in filePathsArray {
                if filePath.hasPrefix("nfx") {
                    try NSFileManager.defaultManager().removeItemAtPath((documentsPath as NSString).stringByAppendingPathComponent(filePath))
                }
            }
            
        } catch {}
    }
    
    func getIgnoredURLs() -> [String]
    {
        return self.ignoredURLs
    }
    
    func getSelectedGesture() -> ENFXGesture
    {
        return self.selectedGesture
    }
    
    func cacheFilters(selectedFilters: [Bool])
    {
        self.filters = selectedFilters
    }
    
    func getCachedFilters() -> [Bool]
    {
        if self.filters.count == 0 {
            self.filters = [Bool](count: HTTPModelShortType.allValues.count, repeatedValue: true)
        }
        return self.filters
    }
    
}

#if os(iOS)

extension NFX {
    
    private func showNFXFollowingPlatform()
    {
        var navigationController: UINavigationController?
        
        var listController: NFXListController_iOS
        listController = NFXListController_iOS()
        
        navigationController = UINavigationController(rootViewController: listController)
        navigationController!.navigationBar.translucent = false
        navigationController!.navigationBar.tintColor = UIColor.NFXOrangeColor()
        navigationController!.navigationBar.barTintColor = UIColor.NFXStarkWhiteColor()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.NFXOrangeColor()]
        
        presentingViewController?.presentViewController(navigationController!, animated: true, completion: nil)
    }
    
    private func hideNFXFollowingPlatform(completion: (() -> Void)?)
    {
        presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let notNilCompletion = completion {
                notNilCompletion()
            }
        })
    }
    
    private var presentingViewController: UIViewController?
        {
            let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            return rootViewController?.presentedViewController ?? rootViewController
    }
    
}

#elseif os(OSX)
    
extension NFX {
    
    public func windowDidClose() {
        self.presented = false
    }
    
    private func setupNetfoxMenuItem() {
        self.nfxMenuItem.target = self
        self.nfxMenuItem.action = "motionDetected"
        self.nfxMenuItem.keyEquivalent = "n"
        self.nfxMenuItem.keyEquivalentModifierMask = Int(NSEventModifierFlags.CommandKeyMask.rawValue | NSEventModifierFlags.ShiftKeyMask.rawValue)
    }
    
    private func addNetfoxToMainMenu() {
        self.setupNetfoxMenuItem()
        if let menu = self.mainMenu {
            menu.insertItem(self.nfxMenuItem, atIndex: 0)
        }
    }
    
    private func removeNetfoxFromMainmenu() {
        if let menu = self.mainMenu {
            menu.removeItem(self.nfxMenuItem)
        }
    }
    
    private func showNFXFollowingPlatform()  {
        if self.windowController == nil {
            self.windowController = NFXWindowController(windowNibName: "NetfoxWindow")
        }
        self.windowController?.showWindow(nil)
    }
    
    private func hideNFXFollowingPlatform(completion: (() -> Void)?)
    {
        self.windowController?.close()
        if let notNilCompletion = completion {
            notNilCompletion()
        }
    }
    
}
    
#endif
