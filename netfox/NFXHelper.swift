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
        return (self as? NSHTTPURLResponse)?.statusCode ?? -1
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
        let basse64Image = "iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAB9klEQVRIibVWy3HjMAxlCSpBFwvv 6A7iDqKzR0BYwnYQdxCX4A7sDqwO4g6kO5FhCdoDRa8+lOJ8FjM6AcTD90HGPChOcFBBFz8nODz6 9mFxjFqrojTGGK2KUpku33bm95utMuwchG5+v9lGG8d0m9oow0abzwBax3RTprO3eWaMMd4iV0E3 cijovEUe9HmmTOfwDu0iUASIBip0VEarjKsy2mkPnOBw1wsaFTqm/IxTrYpSGW2M3hhjXIVdqnTT ErkKu3uwNs9U0MT+zR8ITjGi74oKHVVwWjQItUW7GMVnAIlqJMUx6uR0hR5cVdAp4/oheJ2BMKwy rqsA3iJXRjsHppsyXWLtQ6/o4oTeE0BtnLpUhE1qk4M+vXgBKGEv6JzQ+z1jFXRaFeXSbA+XcKar sHOMOqXz+81Wq6JUQWemSzaL9jf0gfDo+b9kIvSsgu5ec8d0W+nJORnlWk/isEzZOlJCKhtlOnvG U8wgctUcODFdc4fLe+IYdYgSdeqeKMMule9fJj3vDLnoK9Jz3frGK9PlV7hroYd9quMa93P+suqU Yadc198VOzMe3gFv88wxvYUDhloFzQfTn5GjMEVN38PWMb15m2er92QI1FPM6UuXUXBSQbMKMAJK UP1wNBdv/Ao9PSSOUcep+/HfyiLID/67/gLwVb93+jhgUQAAAABJRU5ErkJggg=="
                
        if let imageData = NSData(base64EncodedString: basse64Image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
            return UIImage(data: imageData)!

        } else {
            return UIImage()
        }
        
    }
}