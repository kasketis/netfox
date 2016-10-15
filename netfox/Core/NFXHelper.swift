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
    class func NFXFont(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
    class func NFXFontBold(_ size: CGFloat) -> UIFont
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

extension URLRequest
{
    func getNFXURL() -> String
    {
        if (url != nil) {
            return url!.absoluteString;
        } else {
            return "-"
        }
    }
    
    func getNFXMethod() -> String
    {
        if (httpMethod != nil) {
            return httpMethod!
        } else {
            return "-"
        }
    }
    
    func getNFXCachePolicy() -> String
    {
        switch cachePolicy {
        case .useProtocolCachePolicy: return "UseProtocolCachePolicy"
        case .reloadIgnoringLocalCacheData: return "ReloadIgnoringLocalCacheData"
        case .reloadIgnoringLocalAndRemoteCacheData: return "ReloadIgnoringLocalAndRemoteCacheData"
        case .returnCacheDataElseLoad: return "ReturnCacheDataElseLoad"
        case .returnCacheDataDontLoad: return "ReturnCacheDataDontLoad"
        case .reloadRevalidatingCacheData: return "ReloadRevalidatingCacheData"
        }
        
    }
    
    func getNFXTimeout() -> String
    {
        return String(Double(timeoutInterval))
    }
    
    func getNFXHeaders() -> [AnyHashable: Any]
    {
        if (allHTTPHeaderFields != nil) {
            return allHTTPHeaderFields!
        } else {
            return Dictionary()
        }
    }
    
    func getNFXBody() -> Data
    {
        return httpBody ?? URLProtocol.property(forKey: "NFXBodyData", in: self) as? Data ?? Data()
    }
}

extension URLResponse
{
    func getNFXStatus() -> Int
    {
        return (self as? HTTPURLResponse)?.statusCode ?? 999
    }
    
    func getNFXHeaders() -> Dictionary<String, String>
    {
        return (self as? HTTPURLResponse)?.allHeaderFields as! [String : String]? ?? Dictionary()
    }
}

extension NFXImage
{
    class func NFXSettings() -> NFXImage
    {
    #if os (iOS)
        return UIImage(data: NFXAssets.getImage(NFXAssetName.settings), scale: 1.7)!
    #elseif os(OSX)
        return NSImage(data: NFXAssets.getImage(NFXAssetName.SETTINGS))!
    #endif
    }
    
    class func NFXInfo() -> NFXImage
    {
    #if os (iOS)
        return UIImage(data: NFXAssets.getImage(NFXAssetName.info), scale: 1.7)!
    #elseif os(OSX)
        return NSImage(data: NFXAssets.getImage(NFXAssetName.INFO))!
    #endif
    }
    
    class func NFXStatistics() -> NFXImage
    {
    #if os (iOS)
        return UIImage(data: NFXAssets.getImage(NFXAssetName.statistics), scale: 1.7)!
    #elseif os(OSX)
        return NSImage(data: NFXAssets.getImage(NFXAssetName.STATISTICS))!
    #endif
    }
}

extension Date
{
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool
    {
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            return true
        } else {
            return false
        }
    }
}

class NFXDebugInfo {
    
    class func getNFXAppName() -> String
    {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    class func getNFXAppVersionNumber() -> String
    {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    class func getNFXAppBuildNumber() -> String
    {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    class func getNFXBundleIdentifier() -> String
    {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    class func getNFXOSVersion() -> String
    {
    #if os(iOS)
        return UIDevice.current.systemVersion
    #elseif os(OSX)
        return NSProcessInfo.processInfo().operatingSystemVersionString
    #endif
    }
    
    class func getNFXDeviceType() -> String
    {
    #if os(iOS)
        return UIDevice.getNFXDeviceType() 
    #elseif os(OSX)
        return "Not implemented yet. PR welcomes"
    #endif
    }
    
    class func getNFXDeviceScreenResolution() -> String
    {
    #if os(iOS)
        let scale = UIScreen.main.scale
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width * scale
        let height = bounds.size.height * scale
        return "\(width) x \(height)"
    #elseif os(OSX)
        return "0"
    #endif
    }
    
    class func getNFXIP(_ completion:@escaping (_ result: String) -> Void)
    {
        var req: NSMutableURLRequest
        req = NSMutableURLRequest(url: URL(string: "https://api.ipify.org/?format=json")!)
        URLProtocol.setProperty("1", forKey: "NFXInternal", in: req)
        
        let session = URLSession.shared
        session.dataTask(with: req as URLRequest, completionHandler: { (data, response, error) in
            do {
                let rawJsonData = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments])
                if let ipAddress = (rawJsonData as AnyObject).value(forKey: "ip") {
                    completion(ipAddress as! String)
                } else {
                    completion("-")
                }
            } catch {
                completion("-")
            }
            
            }) .resume()
    }
    
}
