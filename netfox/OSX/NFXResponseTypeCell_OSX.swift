//
//  NFXResponseTypeCell_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa
    
class NFXResponseTypeCell_OSX: NSTableCellView {
    
    @IBOutlet var typeLabel: NSTextField!
    @IBOutlet var activeCheckbox: NSButton!
}

#endif
