//
//  NFXBodyDetailsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

enum NFXBodyType: Int
{
    case REQUEST  = 0
    case RESPONSE = 1
}


class NFXBodyDetailsController: NFXGenericController
{
    var bodyView: UITextView = UITextView()
    var iIndex: Int = 0
    var bodyType: NFXBodyType = NFXBodyType.RESPONSE
    
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