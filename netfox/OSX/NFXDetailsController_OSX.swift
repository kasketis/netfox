//
//  NFXDetailsController_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa

class NFXDetailsController_OSX: NFXDetailsController {

    @IBOutlet var textViewInfo: NSTextView!
    @IBOutlet var textViewRequest: NSTextView!
    @IBOutlet var textViewBodyRequest: NSTextView!
    @IBOutlet var textViewResponse: NSTextView!
    @IBOutlet var textViewBodyResponse: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func selectedModel(_ model: NFXHTTPModel) {
        super.selectedModel(model)
        self.textViewInfo.textStorage?.setAttributedString(self.getInfoStringFromObject(model))
        self.textViewRequest.textStorage?.setAttributedString(self.getRequestStringFromObject(model))

        let bodyRequest: NSAttributedString
        if model.requestBodyLength == 0 {
            bodyRequest = self.formatNFXString(String(self.getRequestBodyStringFooter(model)))
        } else {
            bodyRequest = self.formatNFXString(String(model.getRequestBody()))
        }
        self.textViewBodyRequest.textStorage?.setAttributedString(bodyRequest)
        
        self.textViewResponse.textStorage?.setAttributedString(self.getResponseStringFromObject(model))
        let bodyResponse: NSAttributedString
        if model.responseBodyLength == 0 {
            bodyResponse = self.formatNFXString(String(self.getResponseBodyStringFooter(model)))
        } else {
            bodyResponse = self.formatNFXString(String(model.getResponseBody()))
        }
        self.textViewBodyResponse.textStorage?.setAttributedString(bodyResponse)
    }
}

#endif
