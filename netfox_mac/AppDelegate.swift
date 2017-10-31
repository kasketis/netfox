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
        // Insert code here to initialize your application
        NFX.sharedInstance().start()
        
        
        loadAllRequests()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    func loadAllRequests() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        if let url = URL(string: "http://localhost:\(NFXServer.port)/\(NFXServer.allRequests)") {
            let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Failed \(error)")
                } else {
                    guard let data = data else { return }
                    guard let response = response as? HTTPURLResponse else {  return }
                    guard response.statusCode >= 200 && response.statusCode < 300 else { return }
                    
                    
                    NFX.sharedInstance().addJSONModels(data)
                    DispatchQueue.main.async {
                        NFX.sharedInstance().show()
                    }
                }
            })
            
            dataTask.resume()
        }

    }

}

