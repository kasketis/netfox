//
//  NFXImageBodyDetailsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

class NFXImageBodyDetailsController: NFXGenericBodyDetailsController
{
    var imageView: UIImageView = UIImageView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Image preview"
        
        self.imageView.frame = CGRectMake(10, 10, CGRectGetWidth(self.view.frame) - 2*10, CGRectGetHeight(self.view.frame) - 2*10)
        self.imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.imageView.contentMode = .ScaleAspectFit
        let data = NSData.init(base64EncodedString: self.selectedModel.getResponseBody() as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)

        self.imageView.image = UIImage(data: data!)

        self.view.addSubview(self.imageView)
        
    }
}