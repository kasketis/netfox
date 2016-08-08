//
//  NFXHelper.swift
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

enum HTTPModelShortType: String
{
    case JSON = "JSON"
    case XML = "XML"
    case HTML = "HTML"
    case IMAGE = "Image"
    case OTHER = "Other"
    
    static let allValues = [JSON, XML, HTML, IMAGE, OTHER]
}

extension NFXColor
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
    
    class func NFXOrangeColor() -> NFXColor
    {
        return NFXColor.init(netHex: 0xec5e28)
    }
    
    class func NFXGreenColor() -> NFXColor
    {
        return NFXColor.init(netHex: 0x38bb93)
    }
    
    class func NFXDarkGreenColor() -> NFXColor
    {
        return NFXColor.init(netHex: 0x2d7c6e)
    }
    
    class func NFXRedColor() -> NFXColor
    {
        return NFXColor.init(netHex: 0xd34a33)
    }
    
    class func NFXDarkRedColor() -> NFXColor
    {
        return NFXColor.init(netHex: 0x643026)
    }
    
    class func NFXStarkWhiteColor() -> NFXColor
    {
        return NFXColor.init(netHex: 0xccc5b9)
    }
    
    class func NFXDarkStarkWhiteColor() -> NFXColor
    {
        return NFXColor.init(netHex: 0x9b958d)
    }
    
    class func NFXLightGrayColor() -> NFXColor
    {
        return NFXColor.init(netHex: 0x9b9b9b)
    }
    
    class func NFXGray44Color() -> NFXColor
    {
        return NFXColor.init(netHex: 0x707070)
    }
    
    class func NFXGray95Color() -> NFXColor
    {
        return NFXColor.init(netHex: 0xf2f2f2)
    }
    
    class func NFXBlackColor() -> NFXColor
    {
        return NFXColor.init(netHex: 0x231f20)
    }
}

extension NFXFont
{
#if os(iOS)
    class func NFXFont(size: CGFloat) -> UIFont
    {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
    class func NFXFontBold(size: CGFloat) -> UIFont
    {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
    
#elseif os(OSX)
    class func NFXFont(size: CGFloat) -> NSFont
    {
        return NSFont(name: "HelveticaNeue", size: size)!
    }
    
    class func NFXFontBold(size: CGFloat) -> NSFont
    {
        return NSFont(name: "HelveticaNeue-Bold", size: size)!
    }
#endif
}

extension NSURLRequest
{
    func getNFXURL() -> String
    {
        return URL?.absoluteString ?? "-"
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

extension NFXImage
{
    class func NFXSettings() -> NFXImage
    {
    #if os (iOS)
        return UIImage(data: NFXAssets.getImage(NFXAssetName.SETTINGS), scale: 1.7)!
    #elseif os(OSX)
        return NSImage(data: NFXAssets.getImage(NFXAssetName.SETTINGS))!
    #endif
    }
    
    class func NFXInfo() -> NFXImage
    {
    #if os (iOS)
        return UIImage(data: NFXAssets.getImage(NFXAssetName.INFO), scale: 1.7)!
    #elseif os(OSX)
        return NSImage(data: NFXAssets.getImage(NFXAssetName.INFO))!
    #endif
    }
    
    class func NFXStatistics() -> NFXImage
    {
    #if os (iOS)
        return UIImage(data: NFXAssets.getImage(NFXAssetName.STATISTICS), scale: 1.7)!
    #elseif os(OSX)
        return NSImage(data: NFXAssets.getImage(NFXAssetName.STATISTICS))!
    #endif
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
    
    class func getNFXOSVersion() -> String
    {
    #if os(iOS)
        return UIDevice.currentDevice().systemVersion ?? ""
    #elseif os(OSX)
        return NSProcessInfo.processInfo().operatingSystemVersionString
    #endif
    }
    
    class func getNFXDeviceType() -> String
    {
    #if os(iOS)
        return UIDevice.getNFXDeviceType() ?? ""
    #elseif os(OSX)
        return "Not implemented yet. PR welcomes"
    #endif
    }
    
    class func getNFXDeviceScreenResolution() -> String
    {
    #if os(iOS)
        let scale = UIScreen.mainScreen().scale
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width * scale
        let height = bounds.size.height * scale
        return "\(width) x \(height)"
    #elseif os(OSX)
        return "0"
    #endif
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
