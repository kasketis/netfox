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

private func podPlistVersion() -> String? {
    guard let path = Bundle(identifier: "com.kasketis.netfox-iOS")?.infoDictionary?["CFBundleShortVersionString"] as? String else { return nil }
    return path
}

// TODO: Carthage support
let nfxVersion = podPlistVersion() ?? "0"

// Notifications posted when NFX opens/closes, for client application that wish to log that information.
let nfxWillOpenNotification = "NFXWillOpenNotification"
let nfxWillCloseNotification = "NFXWillCloseNotification"

@objc
open class NFX: NSObject {
    
    // MARK: - Properties
    
    #if os(OSX)
        var windowController: NFXWindowController?
        let mainMenu: NSMenu? = NSApp.mainMenu?.items[1].submenu
        var nfxMenuItem: NSMenuItem = NSMenuItem(title: "netfox", action: #selector(NFX.show), keyEquivalent: String.init(describing: (character: NSF9FunctionKey, length: 1)))
    #endif
    
    fileprivate enum Constants: String {
        case alreadyStartedMessage = "Already started!"
        case alreadyStoppedMessage = "Already stopped!"
        case startedMessage = "Started!"
        case stoppedMessage = "Stopped!"
        case prefixForCheck = "nfx"
        case nibName = "NetfoxWindow"
    }
    
    fileprivate var started: Bool = false
    fileprivate var presented: Bool = false
    fileprivate var enabled: Bool = false
    fileprivate var selectedGesture: ENFXGesture = .shake
    fileprivate var ignoredURLs = [String]()
    fileprivate var ignoredURLsRegex = [NSRegularExpression]()
    fileprivate var filters = [Bool]()
    fileprivate var lastVisitDate: Date = Date()
    
    internal var cacheStoragePolicy = URLCache.StoragePolicy.notAllowed
    
    // swiftSharedInstance is not accessible from ObjC
    class var swiftSharedInstance: NFX {
        struct Singleton {
            static let instance = NFX()
        }
        return Singleton.instance
    }
    
    // the sharedInstance class method can be reached from ObjC
    @objc open class func sharedInstance() -> NFX {
        return NFX.swiftSharedInstance
    }
    
    @objc public enum ENFXGesture: Int {
        case shake
        case custom
    }

    @objc open func start() {
        guard !started else {
            showMessage(Constants.alreadyStartedMessage.rawValue)
            return
        }

        started = true
        URLSessionConfiguration.implementNetfox()
        register()
        enable()
        clearOldData()
        showMessage(Constants.startedMessage.rawValue)
        #if os(OSX)
        addNetfoxToMainMenu()
        #endif
    }
    
    @objc open func stop() {
        guard started else {
            showMessage(Constants.alreadyStoppedMessage.rawValue)
            return
        }
        
        unregister()
        disable()
        clearOldData()
        started = false
        showMessage(Constants.stoppedMessage.rawValue)
        #if os(OSX)
        removeNetfoxFromMainmenu()
        #endif
    }
    
    fileprivate func showMessage(_ msg: String) {
        print("netfox \(nfxVersion) - [https://github.com/kasketis/netfox]: \(msg)")
    }
    
    internal func isEnabled() -> Bool {
        return enabled
    }
    
    internal func enable() {
        enabled = true
    }
    
    internal func disable() {
        enabled = false
    }
    
    fileprivate func register() {
        URLProtocol.registerClass(NFXProtocol.self)
    }
    
    fileprivate func unregister() {
        URLProtocol.unregisterClass(NFXProtocol.self)
    }
    
    @objc func motionDetected() {
        guard started else { return }
        toggleNFX()
    }
    
    @objc open func isStarted() -> Bool {
        return started
    }
    
    @objc open func setCachePolicy(_ policy: URLCache.StoragePolicy) {
        cacheStoragePolicy = policy
    }
    
    @objc open func setGesture(_ gesture: ENFXGesture) {
        selectedGesture = gesture
        #if os(OSX)
        if gesture == .shake {
            addNetfoxToMainMenu()
        } else {
            removeNetfoxFromMainmenu()
        }
        #endif
    }
    
    @objc open func show() {
        guard started else { return }
        showNFX()
    }
    
    @objc open func hide() {
        guard started else { return }
        hideNFX()
    }

    @objc open func toggle()
    {
        guard self.started else { return }
        toggleNFX()
    }
    
    @objc open func ignoreURL(_ url: String) {
        ignoredURLs.append(url)
    }
    
    @objc open func ignoreURLs(_ urls: [String]) {
        ignoredURLs.append(contentsOf: urls)
    }
    
    @objc open func ignoreURLsWithRegex(_ regex: String) {
        ignoredURLsRegex.append(NSRegularExpression(regex))
    }
    
    @objc open func ignoreURLsWithRegexes(_ regexes: [String]) {
        ignoredURLsRegex.append(contentsOf: regexes.map { NSRegularExpression($0) })
    }
    
    internal func getLastVisitDate() -> Date {
        return lastVisitDate
    }
    
    fileprivate func showNFX() {
        if presented {
            return
        }
        
        showNFXFollowingPlatform()
        presented = true

    }
    
    fileprivate func hideNFX() {
        if !presented {
            return
        }
        
        NotificationCenter.default.post(name: Notification.Name.NFXDeactivateSearch, object: nil)
        hideNFXFollowingPlatform { () -> Void in
            self.presented = false
            self.lastVisitDate = Date()
        }
    }

    fileprivate func toggleNFX() {
        presented ? hideNFX() : showNFX()
    }
    
    internal func clearOldData() {
        NFXHTTPModelManager.sharedInstance.clear()
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
            let filePathsArray = try FileManager.default.subpathsOfDirectory(atPath: documentsPath)
            for filePath in filePathsArray {
                if filePath.hasPrefix(Constants.prefixForCheck.rawValue) {
                    try FileManager.default.removeItem(atPath: (documentsPath as NSString).appendingPathComponent(filePath))
                }
            }
            
            try FileManager.default.removeItem(atPath: NFXPath.SessionLog)
        } catch {}
    }
    
    func getIgnoredURLs() -> [String] {
        return ignoredURLs
    }
    
    func getIgnoredURLsRegexes() -> [NSRegularExpression] {
        return ignoredURLsRegex
    }
    
    func getSelectedGesture() -> ENFXGesture {
        return selectedGesture
    }
    
    func cacheFilters(_ selectedFilters: [Bool]) {
        filters = selectedFilters
    }
    
    func getCachedFilters() -> [Bool] {
        if filters.isEmpty {
            filters = [Bool](repeating: true, count: HTTPModelShortType.allValues.count)
        }
        return filters
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

    fileprivate func showNFXFollowingPlatform() {
        let navigationController = UINavigationController(rootViewController: NFXListController_iOS())
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = UIColor.NFXOrangeColor()
        navigationController.navigationBar.barTintColor = UIColor.NFXStarkWhiteColor()
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.NFXOrangeColor()]

        if #available(iOS 13.0, *) {
            navigationController.presentationController?.delegate = self
        }

        presentingViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    fileprivate func hideNFXFollowingPlatform(_ completion: (() -> Void)?) {
        presentingViewController?.dismiss(animated: true, completion: { () -> Void in
            if let notNilCompletion = completion {
                notNilCompletion()
            }
        })
    }
}

extension NFX: UIAdaptivePresentationControllerDelegate {

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController)
    {
        guard self.started else { return }
        self.presented = false
    }
}

#elseif os(OSX)
    
extension NFX {
    
    public func windowDidClose() {
        presented = false
    }
    
    private func setupNetfoxMenuItem() {
        nfxMenuItem.target = self
        nfxMenuItem.action = #selector(NFX.motionDetected)
        nfxMenuItem.keyEquivalent = "n"
        nfxMenuItem.keyEquivalentModifierMask = NSEvent.ModifierFlags(rawValue: UInt(Int(NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue)))
    }
    
    public func addNetfoxToMainMenu() {
        setupNetfoxMenuItem()
        if let menu = mainMenu {
            menu.insertItem(nfxMenuItem, at: 0)
        }
    }
    
    public func removeNetfoxFromMainmenu() {
        if let menu = mainMenu {
            menu.removeItem(nfxMenuItem)
        }
    }
    
    public func showNFXFollowingPlatform()  {
        if windowController == nil {
            #if swift(>=4.2)
            let nibName = Constants.nibName.rawValue
            #else
            let nibName = NSNib.Name(rawValue: Constants.nibName.rawValue)
            #endif

            windowController = NFXWindowController(windowNibName: nibName)
        }
        windowController?.showWindow(nil)
    }
    
    public func hideNFXFollowingPlatform(completion: (() -> Void)?) {
        windowController?.close()
        if let notNilCompletion = completion {
            notNilCompletion()
        }
    }
}

#endif
