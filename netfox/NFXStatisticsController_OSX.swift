//
//  NFXStatisticsController_OSX.swift
//  KaraFun
//
//  Created by vince on 27/01/2016.
//  Copyright © 2016 Recisio. All rights reserved.
//

#if os(OSX)
    
import Cocoa
    
class NFXStatisticsController_OSX: NFXStatisticsController {
 
    @IBOutlet var textView: NSTextView!
    
    override func reloadData() {
        super.reloadData()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.textView.textStorage?.setAttributedString(self.getReportString())
        }
    }
}

#endif
