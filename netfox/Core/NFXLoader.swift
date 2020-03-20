//
//  NFXLoader.swift
//  netfox_ios
//
//  Created by Stefan Haider on 20.03.20.
//  Copyright © 2020 kasketis. All rights reserved.
//

import UIKit

class NFXLoader {

    class func load() {
        let implementNetfoxSelector = NSSelectorFromString("implementNetfox")
        if URLSessionConfiguration.responds(to: implementNetfoxSelector) {
            URLSessionConfiguration.perform(implementNetfoxSelector)
        }
    }
}
