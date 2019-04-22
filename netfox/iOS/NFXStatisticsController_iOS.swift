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
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView.autoresizesSubviews = true
        self.scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(self.scrollView)
        
        self.textLabel = UILabel()
        self.textLabel.frame = CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20);
        self.textLabel.font = UIFont.NFXFont(size: 13)
        self.textLabel.textColor = UIColor.NFXGray44Color()
        self.textLabel.numberOfLines = 0
        self.textLabel.attributedText = getReportString()
        self.textLabel.sizeToFit()
        self.scrollView.addSubview(self.textLabel)
        
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: self.textLabel.frame.maxY)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NFXGenericController.reloadData),
            name: NSNotification.Name.NFXReloadData,
            object: nil)
        
    }
    
    override func reloadData()
    {
        super.reloadData()
        DispatchQueue.main.async { () -> Void in
            self.textLabel.attributedText = self.getReportString()
        }
    }
}

#endif
