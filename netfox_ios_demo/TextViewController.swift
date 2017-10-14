//
//  TextViewController.swift
//  netfox_ios_demo
//
//  Created by Nathan Jangula on 10/12/17.
//  Copyright © 2017 kasketis. All rights reserved.
//

import UIKit
import netfox_ios

class TextViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    let session: URLSession!
    var dataTask: URLSessionDataTask?
    
    required init?(coder aDecoder: NSCoder) {
        session = URLSession(configuration: URLSessionConfiguration.default)
        super.init(coder: aDecoder)
    }
    
    @IBAction func tappedLoad(_ sender: Any) {
        dataTask?.cancel()
        
        if let url = URL(string: "https://api.chucknorris.io/jokes/random") {
            dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    self.handleCompletion(error: error.localizedDescription, data: data)
                } else {
                    guard let data = data else { self.handleCompletion(error: "Invalid data", data: nil); return }
                    guard let response = response as? HTTPURLResponse else { self.handleCompletion(error: "Invalid response", data: data); return }
                    guard response.statusCode >= 200 && response.statusCode < 300 else { self.handleCompletion(error: "Invalid response code", data: data); return }
                    
                    self.handleCompletion(error: error?.localizedDescription, data: data)
                }
            })
            
            dataTask?.resume()
        }
    }
    
    private func handleCompletion(error: String?, data: Data?) {
        DispatchQueue.main.async {
            
            if let error = error {
                NSLog(error)
                return
            }
            
            if let data = data {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let message = dict?["value"] as? String {
                        self.textView.text = message
                    }
                } catch {
                    
                }
            }
        }
    }
}

