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
    case REQUEST  = 0
    case RESPONSE = 1
}

class NFXGenericBodyDetailsController: NFXGenericController
{
    var bodyType: NFXBodyType = NFXBodyType.RESPONSE
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
}