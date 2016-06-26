//
//  NFXGenericBodyDetailsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

enum NFXBodyType: Int
{
    case request  = 0
    case response = 1
}

class NFXGenericBodyDetailsController: NFXGenericController
{
    var bodyType: NFXBodyType = NFXBodyType.response
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
}
