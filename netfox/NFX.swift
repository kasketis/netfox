//
//  NFX.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

let nfxVersion = "1.7.2"

// Notifications posted when NFX opens/closes, for client application that wish to log that information.
let nfxWillOpenNotification = "NFXWillOpenNotification"
let nfxWillCloseNotification = "NFXWillCloseNotification"

@objc
public class NFX: NSObject
{
    
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
        case button
        
        func name() -> String {
            switch self {
            case .shake: return "shake"
            case .custom: return "custom"
            case .button: return "button"
            }
        }
    }
    
    private var started: Bool = false
    private var presented: Bool = false
    private var enabled: Bool = false
    private var selectedGesture: ENFXGesture = .shake
    private var ignoredURLs = [String]()
    private var filters = [Bool]()
    private var lastVisitDate: Date = Date()

    @objc public func start()
    {
        self.started = true
        register()
        enable()
        clearOldData()
        showMessage("Started!")
    }
    
    @objc public func stop()
    {
        unregister()
        disable()
        clearOldData()
        self.started = false
        showMessage("Stopped!")
    }
    
    private func showMessage(_ msg: String) {
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
        URLProtocol.registerClass(NFXProtocol.self)
    }
    
    private func unregister()
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
    
    @objc public func setGesture(_ gesture: ENFXGesture)
    {
        self.selectedGesture = gesture
    }
    
    @objc public func show()
    {
        if (self.started) && (self.selectedGesture == .custom) {
            showNFX()
        } else {
            print("netfox \(nfxVersion) - [ERROR]: Please call start() and setGesture(.custom) first")
        }
    }

    @objc public func buttonShow()
    {
        if (self.started) && (self.selectedGesture == .button) {
            showNFX()
        } else {
            print("netfox \(nfxVersion) - [ERROR]: Please call start() and setGesture(.button) first")
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
    
    @objc public func buttonHide()
    {
        if (self.started) && (self.selectedGesture == .button)
        {
            hideNFX()
        }
        else
        {
            print("netfox \(nfxVersion) - [ERROR]: Please call start() and setGesture(.button) first")
        }
    }
    
    @objc public func ignoreURL(url: String)
    {
        self.ignoredURLs.append(url)
    }
    
    internal func getLastVisitDate() -> Date
    {
        return self.lastVisitDate
    }
    
    private func showNFX()
    {
        if self.presented {
            return
        }
        
        var navigationController: UINavigationController?

        var listController: NFXListController
        listController = NFXListController()
        
        navigationController = UINavigationController(rootViewController: listController)
        navigationController!.navigationBar.isTranslucent = false
        navigationController!.navigationBar.tintColor = UIColor.NFXOrangeColor()
        navigationController!.navigationBar.barTintColor = UIColor.NFXStarkWhiteColor()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.NFXOrangeColor()]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: nfxWillOpenNotification), object: nil)
        self.presented = true
        presentingViewController?.present(navigationController!, animated: true, completion: nil)
    }
    
    private var presentingViewController: UIViewController?
    {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        return rootViewController?.presentedViewController ?? rootViewController
    }
    
    private func hideNFX()
    {
        if !self.presented {
            return
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NFXDeactivateSearch"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: nfxWillCloseNotification), object: nil)
        
        presentingViewController?.dismiss(animated: true, completion: { () -> Void in
            self.presented = false
            self.lastVisitDate = Date()
        })
    }
    
    internal func clearOldData()
    {
        NFXHTTPModelManager.sharedInstance.clear()
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                    FileManager.SearchPathDomainMask.allDomainsMask, true).first!
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
