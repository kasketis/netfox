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
        let l = string.characters.count
        
        let regex1 = try! NSRegularExpression(pattern: "(\\-- Body \\--)|(\\-- Headers \\--)", options: NSRegularExpressionOptions.CaseInsensitive)
        
        
        let matches1 = regex1.matchesInString(string, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<NSTextCheckingResult>
        
        var tempMutableString = NSMutableAttributedString()
        
        tempMutableString = NSMutableAttributedString(string: string)
        
        for match in matches1 {
            tempMutableString.addAttribute(NSFontAttributeName, value: UIFont.NFXFontBold(13), range: match.range)
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.NFXOrangeColor(), range: match.range)
        }
        
        
        let regex2 = try! NSRegularExpression(pattern: "\\[.+?\\]", options: NSRegularExpressionOptions.CaseInsensitive)
        
        
        let matches2 = regex2.matchesInString(string, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<NSTextCheckingResult>
        
        
        for match in matches2 {
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.NFXBlackColor(), range: match.range)
        }
        
        
        return tempMutableString
    }
    
    func reloadData()
    {

    }
}