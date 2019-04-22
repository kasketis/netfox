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
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView.autoresizesSubviews = true
        self.scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(self.scrollView)
        
        self.textLabel = UILabel()
        self.textLabel.frame = CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20);
        self.textLabel.font = UIFont.NFXFont(size: 13)
        self.textLabel.textColor = UIColor.NFXGray44Color()
        self.textLabel.attributedText = self.generateInfoString("Retrieving IP address..")
        self.textLabel.numberOfLines = 0
        self.textLabel.sizeToFit()
        self.scrollView.addSubview(self.textLabel)
        
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: self.textLabel.frame.maxY)
        
        generateInfo()
    }

    func generateInfo()
    {
        NFXDebugInfo.getNFXIP { (result) -> Void in
            DispatchQueue.main.async { () -> Void in
                self.textLabel.attributedText = self.generateInfoString(result)
            }
        }
    }
}

#endif
