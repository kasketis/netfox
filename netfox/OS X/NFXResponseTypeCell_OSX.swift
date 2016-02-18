//
//  NFXResponseTypeCell_OSX.swift
//  KaraFun
//
//  Created by vince on 28/01/2016.
//  Copyright © 2016 Recisio. All rights reserved.
//

#if os(OSX)
    
import Cocoa
    
class NFXResponseTypeCell_OSX: NSTableCellView {
    
    @IBOutlet var typeLabel: NSTextField!
    @IBOutlet var activeCheckbox: NSButton!
    
}

#endif
