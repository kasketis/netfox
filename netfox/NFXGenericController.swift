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
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        self.view.backgroundColor = UIColor.NFXGray95Color()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    func selectedModel(_ model: NFXHTTPModel)
    {
        self.selectedModel = model
    }
    
    func formatNFXString(_ string: String) -> AttributedString
    {
        var tempMutableString = NSMutableAttributedString()
        tempMutableString = NSMutableAttributedString(string: string)
        
        let l = string.characters.count
        
        let regexBodyHeaders = try! RegularExpression(pattern: "(\\-- Body \\--)|(\\-- Headers \\--)", options: RegularExpression.Options.caseInsensitive)
        let matchesBodyHeaders = regexBodyHeaders.matches(in: string, options: RegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<TextCheckingResult>
        
        for match in matchesBodyHeaders {
            tempMutableString.addAttribute(NSFontAttributeName, value: UIFont.NFXFontBold(14), range: match.range)
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.NFXOrangeColor(), range: match.range)
        }
        
        let regexKeys = try! RegularExpression(pattern: "\\[.+?\\]", options: RegularExpression.Options.caseInsensitive)
        let matchesKeys = regexKeys.matches(in: string, options: RegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<TextCheckingResult>
        
        for match in matchesKeys {
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.NFXBlackColor(), range: match.range)
        }
        
        
        return tempMutableString
    }
    
    func reloadData()
    {
    }
}
