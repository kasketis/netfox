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

let nfxVersion = "1.8"

// Notifications posted when NFX opens/closes, for client application that wish to log that information.
let nfxWillOpenNotification = "NFXWillOpenNotification"
let nfxWillCloseNotification = "NFXWillCloseNotification"

@objc
open class NFX: NSObject
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
    open class func sharedInstance() -> NFX
    {
        return NFX.swiftSharedInstance
    }
    
    @objc public enum ENFXGesture: Int
    {
        case shake
        case custom
    }
    
    fileprivate var started: Bool = false
    fileprivate var presented: Bool = false
    fileprivate var enabled: Bool = false
    fileprivate var selectedGesture: ENFXGesture = .shake
    fileprivate var ignoredURLs = [String]()
    fileprivate var filters = [Bool]()
    fileprivate var lastVisitDate: Date = Date()

    @objc open func start()
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
    
    @objc open func stop()
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
    
    fileprivate func showMessage(_ msg: String) {
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
    
    fileprivate func register()
    {
        URLProtocol.registerClass(NFXProtocol.self)
    }
    
    fileprivate func unregister()
    {
        URLProtocol.unregisterClass(NFXProtocol.self)
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
    
    @objc open func setGesture(_ gesture: ENFXGesture)
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
    
    @objc open func show()
    {
        if (self.started) && (self.selectedGesture == .custom) {
            showNFX()
        } else {
            print("netfox \(nfxVersion) - [ERROR]: Please call start() and setGesture(.custom) first")
        }
    }
    
    @objc open func hide()
    {
        if (self.started) && (self.selectedGesture == .custom) {
            hideNFX()
        } else {
            print("netfox \(nfxVersion) - [ERROR]: Please call start() and setGesture(.custom) first")
        }
    }
    
    @objc open func ignoreURL(_ url: String)
    {
        self.ignoredURLs.append(url)
    }
    
    internal func getLastVisitDate() -> Date
    {
        return self.lastVisitDate
    }
    
    fileprivate func showNFX()
    {
        if self.presented {
            return
        }
        
        self.showNFXFollowingPlatform()
        self.presented = true

    }
    
    fileprivate func hideNFX()
    {
        if !self.presented {
            return
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NFXDeactivateSearch"), object: nil)
        self.hideNFXFollowingPlatform { () -> Void in
            self.presented = false
            self.lastVisitDate = Date()
        }
    }
    
    internal func clearOldData()
    {
        NFXHTTPModelManager.sharedInstance.clear()
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
            let filePathsArray = try FileManager.default.subpathsOfDirectory(atPath: documentsPath)
            for filePath in filePathsArray {
                if filePath.hasPrefix("nfx") {
                    try FileManager.default.removeItem(atPath: (documentsPath as NSString).appendingPathComponent(filePath))
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
    
    func cacheFilters(_ selectedFilters: [Bool])
    {
        self.filters = selectedFilters
    }
    
    func getCachedFilters() -> [Bool]
    {
        if self.filters.count == 0 {
            self.filters = [Bool](repeating: true, count: HTTPModelShortType.allValues.count)
        }
        return self.filters
    }
    
}

#if os(iOS)

extension NFX {
    
    fileprivate func showNFXFollowingPlatform()
    {
        var navigationController: UINavigationController?
        
        var listController: NFXListController_iOS
        listController = NFXListController_iOS()
        
        navigationController = UINavigationController(rootViewController: listController)
        navigationController!.navigationBar.isTranslucent = false
        navigationController!.navigationBar.tintColor = UIColor.NFXOrangeColor()
        navigationController!.navigationBar.barTintColor = UIColor.NFXStarkWhiteColor()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.NFXOrangeColor()]
        
        presentingViewController?.present(navigationController!, animated: true, completion: nil)
    }
    
    fileprivate func hideNFXFollowingPlatform(_ completion: (() -> Void)?)
    {
        presentingViewController?.dismiss(animated: true, completion: { () -> Void in
            if let notNilCompletion = completion {
                notNilCompletion()
            }
        })
    }
    
    fileprivate var presentingViewController: UIViewController?
        {
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
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
