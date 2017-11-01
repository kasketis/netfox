//
//  AppDelegate.swift
//  netfox_mac
//
//  Created by Alexandru Tudose on 27/10/2017.
//  Copyright © 2017 kasketis. All rights reserved.
//

import Cocoa
import netfox_osx
import Swifter

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!

    func applicationWillFinishLaunching(_ aNotification: Notification) {
        
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NFX.sharedInstance().start()
        NFX.sharedInstance().show()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
}



