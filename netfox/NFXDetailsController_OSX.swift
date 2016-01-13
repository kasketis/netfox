//
//  NFXDetailsController_OSX.swift
//  NetfoxForMac
//
//  Created by Tom Baranes on 12/01/16.
//  Copyright © 2016 Netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa

class NFXDetailsController_OSX: NFXGenericController {

    override func loadView() {
        self.view = NSView()
    }

    
}

#endif