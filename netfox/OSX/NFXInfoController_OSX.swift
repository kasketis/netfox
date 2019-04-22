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
            DispatchQueue.main.async {
                self.textView.textStorage?.setAttributedString(self.generateInfoString(result))
            }
        }
    }
}

#endif
