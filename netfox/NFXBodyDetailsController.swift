//
//  NFXBodyDetailsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

class NFXBodyDetailsController: UIViewController
{
    var bodyView: UITextView = UITextView()
    var iIndex: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        self.title = "Body details"
        
        self.view.backgroundColor = UIColor.init(netHex: 0xf2f2f2)
        
        let tempObject = NFXHTTPModelManager.sharedInstance.models[self.iIndex]
        
        self.bodyView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        self.bodyView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.bodyView.backgroundColor = UIColor.clearColor()
        self.bodyView.textColor = UIColor.init(netHex: 0x707070)
        self.bodyView.editable = false
        
        self.bodyView.text = tempObject.getResponseBody() as String
        
        self.view.addSubview(self.bodyView)
        
    }
}