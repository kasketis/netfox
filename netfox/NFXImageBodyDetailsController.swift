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
        
        self.imageView.frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 2*10, height: self.view.frame.height - 2*10)
        self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.imageView.contentMode = .scaleAspectFit
//        let data = Data.init(base64Encoded: self.selectedModel.getResponseBody() as String,
//                             options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let data = Data.init(base64Encoded: self.selectedModel.getResponseBody() as String,
                             options: [])

        self.imageView.image = UIImage(data: data!)

        self.view.addSubview(self.imageView)
        
    }
}
