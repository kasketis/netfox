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
        
        guard let url = URL(string: "https://vodafonegr.d3.sc.omtrdc.net/b/ss/vodafonegroupgrdev/1/JS-2.10.0/s94023424465890?AQB=1&pccr=true&&ndh=1&pf=1&t=5%2F5%2F2019%2012%3A44%3A48%203%20-180&sdid=4494C94F22356831-3FAD008680877BF6&ts=2019-06-05T09%3A44%3A48Z&aamlh=6&fid=05647651BEB3DABE-24A46AEE7FE50238&ce=UTF-8&g=https%3A%2F%2Ftags.tiqcdn.com%2Futag%2Fvodafone%2Fgr-universal%2Fdev%2Fmobile.html%3F&c.&a.&CarrierName=vf%20GR&DeviceName=iPhone11%2C6&OSVersion=12.2&Resolution=1242x2688&.a&.c&cc=EUR&ch=My%20CU&c15=202005STATRSV2018-12-11T10%3A49%3A57ZH6cC4%2B%2FXn2%2Ffsqkqcnsu3Plg%3D%3D&v15=202005STATRSV2018-12-11T10%3A49%3A57ZH6cC4%2B%2FXn2%2Ffsqkqcnsu3Plg%3D%3D&c17=undefined&v36=202005STATRSV2018-12-11T10%3A49%3A57ZH6cC4%2B%2FXn2%2Ffsqkqcnsu3Plg%3D%3D&c46=202005STATRSV2018-12-11T10%3A49%3A57ZH6cC4%2B%2FXn2%2Ffsqkqcnsu3Plg%3D%3D&c49=TargetNotAvailable&c65=A1BAA7EBD8CD4F03AE280626936208DC&v65=A1BAA7EBD8CD4F03AE280626936208DC&pe=lnk_o&pev2=no%20link_name&s=414x896&c=32&j=1.6&v=N&k=Y&bw=896&bh=8&mcorgid=C7061CFE532E6B720A490D45%40AdobeOrg&lrt=850&AQE=1") else { return }
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

