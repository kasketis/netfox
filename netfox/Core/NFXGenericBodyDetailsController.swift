//
//  NFXGenericBodyDetailsController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

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