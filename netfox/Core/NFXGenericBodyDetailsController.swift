//
//  NFXGenericBodyDetailsController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

enum NFXBodyType: Int {
    case request  = 0
    case response = 1
}

class NFXGenericBodyDetailsController: NFXGenericController {
    var bodyType: NFXBodyType = NFXBodyType.response
}
