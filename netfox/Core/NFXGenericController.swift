//
//  NFXGenericController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif

class NFXGenericController: NFXViewController
{
    var selectedModel: NFXHTTPModel = NFXHTTPModel()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        #if os(iOS)
        self.edgesForExtendedLayout = .None
        self.view.backgroundColor = NFXColor.NFXGray95Color()
        #elseif os(OSX)
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NFXColor.NFXGray95Color().CGColor
        #endif
    }
    
    func selectedModel(model: NFXHTTPModel)
    {
        self.selectedModel = model
    }
    
    func formatNFXString(string: String) -> NSAttributedString
    {
        var tempMutableString = NSMutableAttributedString()
        tempMutableString = NSMutableAttributedString(string: string)
        
        let l = string.characters.count
        
        let regexBodyHeaders = try! NSRegularExpression(pattern: "(\\-- Body \\--)|(\\-- Headers \\--)", options: NSRegularExpressionOptions.CaseInsensitive)
        let matchesBodyHeaders = regexBodyHeaders.matchesInString(string, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<NSTextCheckingResult>
        
        for match in matchesBodyHeaders {
            tempMutableString.addAttribute(NSFontAttributeName, value: NFXFont.NFXFontBold(14), range: match.range)
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: NFXColor.NFXOrangeColor(), range: match.range)
        }
        
        let regexKeys = try! NSRegularExpression(pattern: "\\[.+?\\]", options: NSRegularExpressionOptions.CaseInsensitive)
        let matchesKeys = regexKeys.matchesInString(string, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<NSTextCheckingResult>
        
        for match in matchesKeys {
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: NFXColor.NFXBlackColor(), range: match.range)
        }
        
        
        return tempMutableString
    }
    
    func reloadData()
    {
    }
}
