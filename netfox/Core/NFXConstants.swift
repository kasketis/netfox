//
//  NFXConstants.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)
import UIKit

typealias NFXColor = UIColor
typealias NFXFont = UIFont
typealias NFXImage = UIImage
typealias NFXViewController = UIViewController
    
#elseif os(OSX)
import Cocoa

typealias NFXColor = NSColor
typealias NFXFont = NSFont
typealias NFXImage = NSImage
typealias NFXViewController = NSViewController
#endif
