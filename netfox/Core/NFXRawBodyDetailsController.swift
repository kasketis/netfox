//
//  NFXRawBodyDetailsController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)

import Foundation
import UIKit

class NFXRawBodyDetailsController: NFXGenericBodyDetailsController
{
    var bodyView: UITextView = UITextView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Body details"
        
        self.bodyView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.bodyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.bodyView.backgroundColor = UIColor.clear
        self.bodyView.textColor = UIColor.NFXGray44Color()
		self.bodyView.textAlignment = .left
        self.bodyView.isEditable = false
        self.bodyView.font = UIFont.NFXFont(13)
        
        switch bodyType {
            case .request:
                self.bodyView.text = self.selectedModel.getRequestBody() as String
        default:
                self.bodyView.text = self.selectedModel.getResponseBody() as String
        }
        
        self.view.addSubview(self.bodyView)
        
    }
}

#endif
