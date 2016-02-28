//
//  NFXInfoController_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa
    
class NFXInfoController_OSX: NFXInfoController {
    
    @IBOutlet var textView: NSTextView!

    override func awakeFromNib() {
        generateInfo()
    }
    
    func generateInfo()
    {
        NFXDebugInfo.getNFXIP { (result) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.textView.textStorage?.setAttributedString(self.generateInfoString(result))
            }
        }
    }

}

#endif