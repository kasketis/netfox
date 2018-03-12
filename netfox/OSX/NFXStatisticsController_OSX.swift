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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NFXGenericController.reloadData),
            name: NSNotification.Name.NFXReloadData,
            object: nil)
    }
    
    override func reloadData() {
        super.reloadData()
        DispatchQueue.main.async {
            self.textView.textStorage?.setAttributedString(self.getReportString())
        }
    }
}

#endif
