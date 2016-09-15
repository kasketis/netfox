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
    var filteredClassNameForAnalytics: String = ""
    
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
    
    func formatNFXString(_ string: String) -> NSAttributedString
    {
        var tempMutableString = NSMutableAttributedString()
        tempMutableString = NSMutableAttributedString(string: string)
        
        let l = string.characters.count
        
        let regexBodyHeaders = try! NSRegularExpression(pattern: "(\\-- Body \\--)|(\\-- Headers \\--)",
                                                        options: .caseInsensitive)
        let matchesBodyHeaders = regexBodyHeaders.matches(in: string,
                                                          options: .withoutAnchoringBounds,
                                                          range: NSMakeRange(0, l))
        
        for match in matchesBodyHeaders {
            tempMutableString.addAttribute(NSFontAttributeName,
                                           value: UIFont.NFXFontBold(size: 14),
                                           range: match.range)
            tempMutableString.addAttribute(NSForegroundColorAttributeName,
                                           value: UIColor.NFXOrangeColor(),
                                           range: match.range)
        }
        
        let regexKeys = try! NSRegularExpression(pattern: "\\[.+?\\]",
                                                 options: .caseInsensitive)
        let matchesKeys = regexKeys.matches(in: string,
                                            options: .withoutAnchoringBounds,
                                            range: NSMakeRange(0, l))
        
        for match in matchesKeys {
            tempMutableString.addAttribute(NSForegroundColorAttributeName,
                                           value: UIColor.NFXBlackColor(),
                                           range: match.range)
        }
        
        
        return tempMutableString
    }
    
    func reloadData()
    {
    }
}
