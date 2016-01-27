//
//  NFXSettingsController_OSX.swift
//  KaraFun
//
//  Created by vince on 27/01/2016.
//  Copyright © 2016 Recisio. All rights reserved.
//

#if os(OSX)

import Cocoa
    
class NFXSettingsController_OSX: NFXSettingsController {
    
    @IBOutlet var nfxVersionLabel: NSTextField!
    @IBOutlet var nfxURLButton: NSButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nfxVersionLabel.stringValue = nfxVersionString
        nfxURLButton.title = nfxURL
    }
    
    // MARK: Actions

    @IBAction func loggingButtonClicked(sender: NSButton) {
        if sender.state == NSOnState {
            NFX.sharedInstance().enable()
        } else {
            NFX.sharedInstance().disable()
        }
    }
    
    @IBAction func clearDataClicked(sender: AnyObject?) {
        NFX.sharedInstance().clearOldData()
    }
    
    @IBAction func nfxURLButtonClicked(sender: NSButton) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: nfxURL)!)
    }
}

#endif