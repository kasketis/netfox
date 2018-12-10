//
//  NFXHelper.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)

import UIKit

#if swift(>=4.2)
public typealias UIEventSubtype = UIEvent.EventSubtype
#endif

extension UIWindow {
    override open func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?)
    {
        if NFX.sharedInstance().getSelectedGesture() == .shake {
            if (event!.type == .motion && event!.subtype == .motionShake) {
                NFX.sharedInstance().motionDetected()
            }
        } else {
            super.motionEnded(motion, with: event)
        }
    }
}

public extension UIDevice
{
    
    class func getNFXDeviceType() -> String
    {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""
        
        for child in mirror.children {
            if let value = child.value as? Int8 , value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        
        return parseDeviceType(identifier)
    }
    
    class func parseDeviceType(_ identifier: String) -> String {
        
        if identifier == "i386" || identifier == "x86_64" {
            return "Simulator"
        }
        
        switch identifier {
        case "iPhone1,1": return "iPhone 2G"
        case "iPhone1,2": return "iPhone 3G"
        case "iPhone2,1": return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "IPhone 4"
        case "iPhone4,1": return "iPhone 4S"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5C"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5S"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone8,1": return "iPhone 6S Plus"
        case "iPhone8,2": return "iPhone 6S"
        case "iPhone8,4": return "iPhone SE"
        case "iPhone9,1", "iPhone9,3": return "iPhone 7"
        case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
            
        case "iPod1,1": return "iPodTouch 1G"
        case "iPod2,1": return "iPodTouch 2G"
        case "iPod3,1": return "iPodTouch 3G"
        case "iPod4,1": return "iPodTouch 4G"
        case "iPod5,1": return "iPodTouch 5G"
        case "iPod7,1": return "iPodTouch 6G"
            
        case "iPad1,1", "iPad1,2": return "iPad"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini Retina"
        case "iPad4,7", "iPad4,8": return "iPad Mini 3"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad6,3", "iPad6,4": return "iPad Pro 9.7-inch"
        case "iPad6,7", "iPad6,8": return "iPad Pro 12.9-inch"
        case "iPad6,11", "iPad6,12": return "iPad 5"
        case "iPad7,1", "iPad7,2": return "iPad Pro 12.9-inch"
        case "iPad7,3", "iPad7,4": return "iPad Pro 10.5-inch"
            
        default: return "Not Available"
        }
    }

}

#endif

protocol DataCleaner {

    func clearData(sourceView: UIView, originingIn sourceRect: CGRect?, then: @escaping () -> ())
}

extension DataCleaner where Self: UIViewController {

    func clearData(sourceView: UIView, originingIn sourceRect: CGRect?, then: @escaping () -> ())
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "Clear data?", message: "", preferredStyle: .actionSheet)
        actionSheetController.popoverPresentationController?.sourceView = sourceView
        if let sourceRect = sourceRect {
            actionSheetController.popoverPresentationController?.sourceRect = sourceRect
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        actionSheetController.addAction(cancelAction)

        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            NFX.sharedInstance().clearOldData()
            then()
        }
        actionSheetController.addAction(yesAction)

        let noAction = UIAlertAction(title: "No", style: .default) { _ in }
        actionSheetController.addAction(noAction)

        self.present(actionSheetController, animated: true, completion: nil)
    }
}
