//
//  NFXInfoController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//


import Foundation
import UIKit

class NFXInfoController: NFXGenericController
{
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
    
    func generateInfoString(ipAddress: String) -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
        tempString += "[App name] \n\(NFXDebugInfo.getNFXAppName())\n\n"
        
        tempString += "[App version] \n\(NFXDebugInfo.getNFXAppVersionNumber()) (build \(NFXDebugInfo.getNFXAppBuildNumber()))\n\n"
        
        tempString += "[App bundle identifier] \n\(NFXDebugInfo.getNFXBundleIdentifier())\n\n"

        tempString += "[Device OS] \niOS \(NFXDebugInfo.getNFXiOSVersion())\n\n"

        tempString += "[Device type] \n\(NFXDebugInfo.getNFXDeviceType())\n\n"

        tempString += "[Device screen resolution] \n\(NFXDebugInfo.getNFXDeviceScreenResolution())\n\n"
        
        tempString += "[Device IP address] \n\(ipAddress)\n\n"

        return formatNFXString(tempString)
    }
    

}