//
//  NFXGenericController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

class NFXGenericController: UIViewController
{
    var selectedModel: NFXHTTPModel = NFXHTTPModel()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        self.view.backgroundColor = UIColor.NFXGray95Color()
        
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
            tempMutableString.addAttribute(NSFontAttributeName, value: UIFont.NFXFontBold(14), range: match.range)
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.NFXOrangeColor(), range: match.range)
        }
        
        let regexKeys = try! NSRegularExpression(pattern: "\\[.+?\\]", options: NSRegularExpressionOptions.CaseInsensitive)
        let matchesKeys = regexKeys.matchesInString(string, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<NSTextCheckingResult>
        
        for match in matchesKeys {
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.NFXBlackColor(), range: match.range)
        }
        
        
        return tempMutableString
    }
    
    func reloadData()
    {
    }
}