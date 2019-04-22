//
//  NFXInfoController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//
    
import Foundation

class NFXInfoController: NFXGenericController
{
    
    func generateInfoString(_ ipAddress: String) -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
        tempString += "[App name] \n\(NFXDebugInfo.getNFXAppName())\n\n"
        
        tempString += "[App version] \n\(NFXDebugInfo.getNFXAppVersionNumber()) (build \(NFXDebugInfo.getNFXAppBuildNumber()))\n\n"
        
        tempString += "[App bundle identifier] \n\(NFXDebugInfo.getNFXBundleIdentifier())\n\n"

        tempString += "[Device OS] \niOS \(NFXDebugInfo.getNFXOSVersion())\n\n"

        tempString += "[Device type] \n\(NFXDebugInfo.getNFXDeviceType())\n\n"

        tempString += "[Device screen resolution] \n\(NFXDebugInfo.getNFXDeviceScreenResolution())\n\n"
        
        tempString += "[Device IP address] \n\(ipAddress)\n\n"

        return formatNFXString(tempString)
    }
}
