//
//  NFXStatisticsController_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa
    
class NFXStatisticsController_OSX: NFXStatisticsController {
 
    @IBOutlet var textView: NSTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        generateStatics()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "reloadData",
            name: "NFXReloadData",
            object: nil)
    }
    
    override func reloadData() {
        super.reloadData()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.textView.textStorage?.setAttributedString(self.getReportString())
        }
    }
}

#endif
