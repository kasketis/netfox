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
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView.autoresizesSubviews = true
        self.scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(self.scrollView)
        
        self.textLabel = UILabel()
        self.textLabel.frame = CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20);
        self.textLabel.font = UIFont.NFXFont(13)
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
    
    func generateInfoString(_ ipAddress: String) -> NSAttributedString
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
