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
    
    override func selectedModel(_ model: NFXHTTPModel) {
        super.selectedModel(model)
        textViewInfo.textStorage?.setAttributedString(getInfoStringFromObject(model))
        textViewRequest.textStorage?.setAttributedString(getRequestStringFromObject(model))

        let bodyRequest: NSAttributedString
        if model.requestBodyLength == 0 {
            bodyRequest = formatNFXString(String(getRequestBodyStringFooter(model)))
        } else {
            bodyRequest = formatNFXString(String(model.getRequestBody()))
        }
        textViewBodyRequest.textStorage?.setAttributedString(bodyRequest)
        
        textViewResponse.textStorage?.setAttributedString(getResponseStringFromObject(model))
        let bodyResponse: NSAttributedString
        if model.responseBodyLength == 0 {
            bodyResponse = formatNFXString(String(getResponseBodyStringFooter(model)))
        } else {
            bodyResponse = formatNFXString(String(model.getResponseBody()))
        }
        textViewBodyResponse.textStorage?.setAttributedString(bodyResponse)
    }
}

#endif
