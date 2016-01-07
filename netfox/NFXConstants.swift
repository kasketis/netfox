//
//  NFXConstants.swift
//  netfox
//
//  Created by Tom Baranes on 07/01/16.
//  Copyright © 2016 kasketis. All rights reserved.
//

#if os(iOS)
    import UIKit
    
    typealias NFXColor = UIColor
    typealias NFXFont = UIFont
    typealias NFXImage = UIImage
#elseif os(OSX)
    import Cocoa
    
    typealias NFXColor = NSColor
    typealias NFXFont = NSFont
    typealias NFXImage = NSImage
#endif