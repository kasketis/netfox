//
//  TextViewController.swift
//  netfox_ios_demo
//
//  Created by Nathan Jangula on 10/12/17.
//  Copyright © 2017 kasketis. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var session: URLSession!
    var dataTask: URLSessionDataTask?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func tappedLoad(_ sender: Any) {
        dataTask?.cancel()
        
        if session == nil {
            session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        }
        
        guard let url = URL(string: "https://api.chucknorris.io/jokes/random") else { return }
        var request = URLRequest(url: url)
        request.httpBody = "TEST".data(using: .utf8)
        dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.handleCompletion(error: error.localizedDescription, data: data)
            } else {
                guard let data = data else { self.handleCompletion(error: "Invalid data", data: nil); return }
                guard let response = response as? HTTPURLResponse else { self.handleCompletion(error: "Invalid response", data: data); return }
                guard response.statusCode >= 200 && response.statusCode < 300 else { self.handleCompletion(error: "Invalid response code", data: data); return }
                
                self.handleCompletion(error: error?.localizedDescription, data: data)
            }
        }
        
        dataTask?.resume()
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

extension TextViewController : URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, nil)
    }
}

