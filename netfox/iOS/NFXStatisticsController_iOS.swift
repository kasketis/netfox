//
//  NFXStatisticsController_iOS.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)

import UIKit
    
class NFXStatisticsController_iOS: NFXStatisticsController {

    var scrollView: UIScrollView = UIScrollView()
    var textLabel: UILabel = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Statistics"
        
        generateStatics()
        
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
        self.textLabel.numberOfLines = 0
        self.textLabel.attributedText = getReportString()
        self.textLabel.sizeToFit()
        self.scrollView.addSubview(self.textLabel)
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame), CGRectGetMaxY(self.textLabel.frame))
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(NFXGenericController.reloadData),
            name: "NFXReloadData",
            object: nil)
        
    }
    
    override func reloadData()
    {
        super.reloadData()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.textLabel.attributedText = self.getReportString()
        }
    }

}

#endif
