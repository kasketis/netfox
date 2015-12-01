//
//  NFXHelper.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import UIKit


enum HTTPModelShortType: String
{
    case JSON = "JSON"
    case XML = "XML"
    case HTML = "HTML"
    case IMAGE = "Image"
    case OTHER = "Other"
    
    static let allValues = [JSON, XML, HTML, IMAGE, OTHER]
}

extension UIWindow
{
    override public func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?)
    {
        if NFX.sharedInstance().getSelectedGesture() == .shake {
            if (event!.type == .Motion && event!.subtype == .MotionShake) {
                NFX.sharedInstance().motionDetected()
            }
        } else {
            super.motionEnded(motion, withEvent: event)
        }
    }
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int)
    {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func NFXOrangeColor() -> UIColor
    {
        return UIColor.init(netHex: 0xec5e28)
    }
    
    class func NFXGreenColor() -> UIColor
    {
        return UIColor.init(netHex: 0x38bb93)
    }
    
    class func NFXDarkGreenColor() -> UIColor
    {
        return UIColor.init(netHex: 0x2d7c6e)
    }
    
    class func NFXRedColor() -> UIColor
    {
        return UIColor.init(netHex: 0xd34a33)
    }
    
    class func NFXDarkRedColor() -> UIColor
    {
        return UIColor.init(netHex: 0x643026)
    }
    
    class func NFXStarkWhiteColor() -> UIColor
    {
        return UIColor.init(netHex: 0xccc5b9)
    }
    
    class func NFXDarkStarkWhiteColor() -> UIColor
    {
        return UIColor.init(netHex: 0x9b958d)
    }
    
    class func NFXLightGrayColor() -> UIColor
    {
        return UIColor.init(netHex: 0x9b9b9b)
    }
    
    class func NFXGray44Color() -> UIColor
    {
        return UIColor.init(netHex: 0x707070)
    }
    
    class func NFXGray95Color() -> UIColor
    {
        return UIColor.init(netHex: 0xf2f2f2)
    }
    
    class func NFXBlackColor() -> UIColor
    {
        return UIColor.init(netHex: 0x231f20)
    }
}

extension UIFont
{
    class func NFXFont(size: CGFloat) -> UIFont
    {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
    class func NFXFontBold(size: CGFloat) -> UIFont
    {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
}

extension NSURLRequest
{
    func getNFXURL() -> String
    {
        if (URL != nil) {
            return URL!.absoluteString;
        } else {
            return "-"
        }
    }
    
    func getNFXMethod() -> String
    {
        if (HTTPMethod != nil) {
            return HTTPMethod!
        } else {
            return "-"
        }
    }
    
    func getNFXCachePolicy() -> String
    {
        switch cachePolicy {
            case .UseProtocolCachePolicy: return "UseProtocolCachePolicy"
            case .ReloadIgnoringLocalCacheData: return "ReloadIgnoringLocalCacheData"
            case .ReloadIgnoringLocalAndRemoteCacheData: return "ReloadIgnoringLocalAndRemoteCacheData"
            case .ReturnCacheDataElseLoad: return "ReturnCacheDataElseLoad"
            case .ReturnCacheDataDontLoad: return "ReturnCacheDataDontLoad"
            case .ReloadRevalidatingCacheData: return "ReloadRevalidatingCacheData"
        }
        
    }
    
    func getNFXTimeout() -> String
    {
        return String(Double(timeoutInterval))
    }
    
    func getNFXHeaders() -> Dictionary<String, String>
    {
        if (allHTTPHeaderFields != nil) {
            return allHTTPHeaderFields!
        } else {
            return Dictionary()
        }
    }
    
    func getNFXBody() -> NSData
    {
        return HTTPBody ?? NSURLProtocol.propertyForKey("NFXBodyData", inRequest: self) as? NSData ?? NSData()
    }
}

extension NSURLResponse
{
    func getNFXStatus() -> Int
    {
        return (self as? NSHTTPURLResponse)?.statusCode ?? 999
    }
    
    func getNFXHeaders() -> Dictionary<NSObject, AnyObject>
    {
        return (self as? NSHTTPURLResponse)?.allHeaderFields ?? Dictionary()
    }
}

extension UIImage
{
    class func NFXSettings() -> UIImage
    {
        return UIImage(data: NFXAssets.getImage(NFXImage.SETTINGS), scale: 1.7)!
    }
    
    class func NFXInfo() -> UIImage
    {
        return UIImage(data: NFXAssets.getImage(NFXImage.INFO), scale: 1.7)!
    }
    
    class func NFXStatistics() -> UIImage
    {
        return UIImage(data: NFXAssets.getImage(NFXImage.STATISTICS), scale: 1.7)!
    }
}

extension NSDate
{
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool
    {
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            return true
        } else {
            return false
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
            if let value = child.value as? Int8 where value != 0 {
                identifier.append(UnicodeScalar(UInt8(value)))
            }
        }
        
        return parseDeviceType(identifier)
    }

    class func parseDeviceType(identifier: String) -> String {
        
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
            
        case "iPod1,1": return "iPodTouch 1G"
        case "iPod2,1": return "iPodTouch 2G"
        case "iPod3,1": return "iPodTouch 3G"
        case "iPod4,1": return "iPodTouch 4G"
        case "iPod5,1": return "iPodTouch 5G"
            
        case "iPad1,1", "iPad1,2": return "iPad"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini Retina"
        case "iPad4,7", "iPad4,8": return "iPad Mini 3"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
            
        default: return "Not Available"
        }
    }
    
    
    
}

class NFXDebugInfo {
    
    class func getNFXAppName() -> String
    {
        return NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    class func getNFXAppVersionNumber() -> String
    {
        return NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    class func getNFXAppBuildNumber() -> String
    {
        return NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    class func getNFXBundleIdentifier() -> String
    {
        return NSBundle.mainBundle().bundleIdentifier ?? ""
    }
    
    class func getNFXiOSVersion() -> String
    {
        return UIDevice.currentDevice().systemVersion ?? ""
    }
    
    class func getNFXDeviceType() -> String
    {
        return UIDevice.getNFXDeviceType() ?? ""
    }
    
    class func getNFXDeviceScreenResolution() -> String
    {
        let scale = UIScreen.mainScreen().scale
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width * scale
        let height = bounds.size.height * scale
        return "\(width) x \(height)"
    }
    
    class func getNFXIP(completion:(result: String) -> Void)
    {
        var req: NSMutableURLRequest
        req = NSMutableURLRequest(URL: NSURL(string: "https://api.ipify.org/?format=json")!)
        NSURLProtocol.setProperty("1", forKey: "NFXInternal", inRequest: req)
        
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(req) { (data, response, error) in
            do {
                let rawJsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: [.AllowFragments])
                if let ipAddress = rawJsonData.valueForKey("ip") {
                    completion(result: ipAddress as! String)
                } else {
                    completion(result: "-")
                }
            } catch {
                completion(result: "-")
            }
            
        }.resume()
    }
    
}
