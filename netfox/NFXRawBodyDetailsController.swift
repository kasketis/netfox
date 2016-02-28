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
        
        self.bodyView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        self.bodyView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.bodyView.backgroundColor = UIColor.clearColor()
        self.bodyView.textColor = UIColor.NFXGray44Color()
		self.bodyView.textAlignment = .Left
        self.bodyView.editable = false
        self.bodyView.font = UIFont.NFXFont(13)
        
        switch bodyType {
            case .REQUEST:
                self.bodyView.text = self.selectedModel.getRequestBody() as String
        default:
                self.bodyView.text = self.selectedModel.getResponseBody() as String
        }
        
        self.view.addSubview(self.bodyView)
        
    }
}