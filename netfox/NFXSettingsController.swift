//
//  NFXSettingsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//
    
import Foundation

class NFXSettingsController: NFXGenericController {
    // MARK: Properties

    let nfxVersionString = "netfox - \(nfxVersion)"
    var nfxURL = "https://github.com/kasketis/netfox"
    
    var tableData = [HTTPModelShortType]()
    var filters = [Bool]()
    
}
