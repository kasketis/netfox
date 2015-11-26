//
//  NFXRawBodyDetailsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

class NFXRawBodyDetailsController: NFXGenericBodyDetailsController
{
    var bodyView: UITextView = UITextView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Body details"
                
        let tempObject = NFXHTTPModelManager.sharedInstance.getModels()[self.iIndex]
        
        self.bodyView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        self.bodyView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.bodyView.backgroundColor = UIColor.clearColor()
        self.bodyView.textColor = UIColor.NFXGray44Color()
        self.bodyView.editable = false
        
        switch bodyType {
            case .REQUEST:
                self.bodyView.text = tempObject.getRequestBody() as String
        default:
                self.bodyView.text = tempObject.getResponseBody() as String
        }
        
        self.view.addSubview(self.bodyView)
        
    }
}