//
//  NFXGenericController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

class NFXGenericController: UIViewController
{
    var selectedModel: NFXHTTPModel = NFXHTTPModel()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        self.view.backgroundColor = UIColor.NFXGray95Color()
        
    }
    
    func selectedModel(model: NFXHTTPModel)
    {
        self.selectedModel = model
    }
}