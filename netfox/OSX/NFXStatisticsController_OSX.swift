//
//  NFXStatisticsController_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa
    
class NFXStatisticsController_OSX: NFXStatisticsController {
 
    @IBOutlet private var textView: NSTextView!

    override func reloadData() {
        super.reloadData()
        
        textView.textStorage?.setAttributedString(getReportString())
    }
}

#endif
