//
//  ImageViewController.swift
//  netfox_ios_demo
//
//  Created by Nathan Jangula on 10/12/17.
//  Copyright © 2017 kasketis. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let session: URLSession!
    var dataTask: URLSessionDataTask?
    
    required init?(coder aDecoder: NSCoder) {
        session = URLSession(configuration: URLSessionConfiguration.default)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedLoadImage(_ sender: Any) {
        dataTask?.cancel()
        
        if let url = URL(string: "https://picsum.photos/\(imageView.frame.size.width)/\(imageView.frame.size.height)/?random") {
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
                let image = UIImage(data: data)
                NSLog("\(image?.size.width ?? 0),\(image?.size.height ?? 0)")
                self.imageView.image = image
            }
        }
    }
}

