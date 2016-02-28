//
//  NFXInfoController_iOS.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)

import UIKit

class NFXInfoController_iOS: NFXInfoController {
    
    var scrollView: UIScrollView = UIScrollView()
    var textLabel: UILabel = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Info"
        
        self.scrollView = UIScrollView()
        self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        self.scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.scrollView.autoresizesSubviews = true
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.scrollView)
        
        self.textLabel = UILabel()
        self.textLabel.frame = CGRectMake(20, 20, CGRectGetWidth(scrollView.frame) - 40, CGRectGetHeight(scrollView.frame) - 20);
        self.textLabel.font = UIFont.NFXFont(13)
        self.textLabel.textColor = UIColor.NFXGray44Color()
        self.textLabel.attributedText = self.generateInfoString("Retrieving IP address..")
        self.textLabel.numberOfLines = 0
        self.textLabel.sizeToFit()
        self.scrollView.addSubview(self.textLabel)
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame), CGRectGetMaxY(self.textLabel.frame))
        
        generateInfo()
        
    }

    func generateInfo()
    {
        NFXDebugInfo.getNFXIP { (result) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.textLabel.attributedText = self.generateInfoString(result)
            }
        }
    }

}

#endif