//
//  WKWebViewController.swift
//  netfox_ios_demo
//
//  Created by Nathan Jangula on 9/14/18.
//  Copyright © 2017 kasketis. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: "https://github.com/kasketis/netfox")!))
    }
}
