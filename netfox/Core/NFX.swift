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

private func podPlist() -> [String: Any]? {
    let path = Bundle.main.path(forResource: "Info", ofType: "plist", inDirectory: "Frameworks/netfox.framework")
    guard let filePath = path else { return nil }
    return NSDictionary(contentsOfFile: filePath) as? [String: Any]
}

// TODO: Carthage support
let nfxVersion = (podPlist()?["CFBundleShortVersionString"] as? String) ?? "1.12.1"

// Notifications posted when NFX opens/closes, for client application that wish to log that information.
let nfxWillOpenNotification = "NFXWillOpenNotification"
let nfxWillCloseNotification = "NFXWillCloseNotification"

@objc
open class NFX: NSObject
{
    #if os(OSX)
        var windowController: NFXWindowController?
        let mainMenu: NSMenu? = NSApp.mainMenu?.items[1].submenu
        var nfxMenuItem: NSMenuItem = NSMenuItem(title: "netfox", action: #selector(NFX.show), keyEquivalent: String.init(describing: (character: NSF9FunctionKey, length: 1)))
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
    @objc open class func sharedInstance() -> NFX
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
    var server: NFXServer?
    internal var cacheStoragePolicy = URLCache.StoragePolicy.notAllowed

    @objc open func start()
    {
        guard !self.started else {
            showMessage("Already started!")
            return
        }

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
    
    @objc public func startServer() {
        if !self.started {
            self.start()
        }
        
        self.server = NFXServer()
        self.server?.startServer()
    }
    
    @objc public func stopServer() {
        self.server?.stopServer()
        self.server = nil
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
    
    @objc func motionDetected()
    {
        guard self.started else { return }
        toggleNFX()
    }
    
    @objc open func setCachePolicy(_ policy: URLCache.StoragePolicy) {
        cacheStoragePolicy = policy
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
        guard self.started else { return }
        showNFX()
    }
    
    @objc open func hide()
    {
        guard self.started else { return }
        hideNFX()
    }

    @objc open func toggle()
    {
        guard self.started else { return }
        toggleNFX()
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
        
        NotificationCenter.default.post(name: Notification.Name.NFXDeactivateSearch, object: nil)
        self.hideNFXFollowingPlatform { () -> Void in
            self.presented = false
            self.lastVisitDate = Date()
        }
    }

    fileprivate func toggleNFX()
    {
        self.presented ? hideNFX() : showNFX()
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
            
            try FileManager.default.removeItem(atPath: NFXPath.SessionLog)
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
    fileprivate var presentingViewController: UIViewController? {
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
		while let controller = rootViewController?.presentedViewController {
			rootViewController = controller
		}
        return rootViewController
    }

    fileprivate func showNFXFollowingPlatform()
    {
        let navigationController = UINavigationController(rootViewController: NFXListController_iOS())
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = UIColor.NFXOrangeColor()
        navigationController.navigationBar.barTintColor = UIColor.NFXStarkWhiteColor()
        #if !swift(>=4.0)
        
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.NFXOrangeColor()]
        #else
            navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.NFXOrangeColor()]
        #endif
        
        presentingViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    fileprivate func hideNFXFollowingPlatform(_ completion: (() -> Void)?)
    {
        presentingViewController?.dismiss(animated: true, completion: { () -> Void in
            if let notNilCompletion = completion {
                notNilCompletion()
            }
        })
    }
}

#elseif os(OSX)
    
extension NFX {
    
    public func windowDidClose() {
        self.presented = false
        
        if Bundle.main.bundleIdentifier == "com.tapptitude.netfox-mac" {
            #if !swift(>=4.0)
                NSApplication.shared().terminate(self)
            #else
                NSApplication.shared.terminate(self)
            #endif
        }
    }
    
    private func setupNetfoxMenuItem() {
        self.nfxMenuItem.target = self
        self.nfxMenuItem.action = #selector(NFX.motionDetected)
        self.nfxMenuItem.keyEquivalent = "n"
        self.nfxMenuItem.keyEquivalentModifierMask = NSEvent.ModifierFlags(rawValue: UInt(Int(NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue)))
    }
    
    public func addNetfoxToMainMenu() {
        self.setupNetfoxMenuItem()
        if let menu = self.mainMenu {
            menu.insertItem(self.nfxMenuItem, at: 0)
        }
    }
    
    public func removeNetfoxFromMainmenu() {
        if let menu = self.mainMenu {
            menu.removeItem(self.nfxMenuItem)
        }
    }
    
    public func showNFXFollowingPlatform()  {
        if self.windowController == nil {
            #if !swift(>=4.0)
                self.windowController = NFXWindowController(windowNibName: "NetfoxWindow")
            #else
                self.windowController = NFXWindowController(windowNibName: NSNib.Name(rawValue: "NetfoxWindow"))
            #endif
        }
        self.windowController?.showWindow(nil)
    }
    
    public func hideNFXFollowingPlatform(completion: (() -> Void)?)
    {
        self.windowController?.close()
        if let notNilCompletion = completion {
            notNilCompletion()
        }
    }
    
}
    
#endif
