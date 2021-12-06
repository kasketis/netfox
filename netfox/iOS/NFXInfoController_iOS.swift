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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Info"
        
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.autoresizesSubviews = true
        scrollView.backgroundColor = UIColor.clear
        view.addSubview(scrollView)
        
        textLabel = UILabel()
        textLabel.frame = CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20);
        textLabel.font = UIFont.NFXFont(size: 13)
        textLabel.textColor = UIColor.NFXGray44Color()
        textLabel.attributedText = generateInfoString("Retrieving IP address..")
        textLabel.numberOfLines = 0
        textLabel.sizeToFit()
        scrollView.addSubview(textLabel)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: textLabel.frame.maxY)
        
        generateInfo()
    }

    func generateInfo() {
        NFXDebugInfo.getNFXIP { (result) -> Void in
            DispatchQueue.main.async { () -> Void in
                self.textLabel.attributedText = self.generateInfoString(result)
            }
        }
    }
}

#endif
