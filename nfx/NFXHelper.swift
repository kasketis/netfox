//
//  NFXHelper.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import UIKit

extension UIWindow
{
    override public func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?)
    {
        if NFX.sharedInstance().selectedGesture == .shake {
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
        if (HTTPBody != nil) {
            return HTTPBody!
        } else {
            return NSData()
        }
    }
}

extension NSURLResponse
{
    func getNFXStatus() -> Int
    {
        return (self as? NSHTTPURLResponse)?.statusCode ?? -1
    }
    
    func getNFXHeaders() -> Dictionary<NSObject, AnyObject>
    {
        return (self as? NSHTTPURLResponse)?.allHeaderFields ?? Dictionary()
    }
}