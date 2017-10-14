//
//  WebViewController.swift
//  netfox_ios_demo
//
//  Created by Nathan Jangula on 10/12/17.
//  Copyright © 2017 kasketis. All rights reserved.
//

import UIKit
import netfox_ios

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        
        webView.loadRequest(URLRequest(url: URL(string: "https://github.com/kasketis/netfox")!))
        
        super.viewDidLoad()
    }
}
