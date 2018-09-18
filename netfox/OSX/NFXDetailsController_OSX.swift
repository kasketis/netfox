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
    @IBOutlet var textViewCodable: NSTextView!
    
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
        var bodyResponse: NSAttributedString
        if model.responseBodyLength == 0 {
            bodyResponse = self.formatNFXString(String(self.getResponseBodyStringFooter(model)))
        } else {
            bodyResponse = self.formatNFXString(String(model.getResponseBody()))
        }
        self.textViewBodyResponse.textStorage?.setAttributedString(bodyResponse)
        
        guard model.responseBodyLength != 0 else {
            bodyResponse = self.formatNFXString(String(self.getResponseBodyStringFooter(model)))
            self.textViewCodable.textStorage?.setAttributedString(bodyResponse)
            return
        }

        do {
            let str = model.getResponseBody() as String
            let data = str.data(using: .utf8)!
            let converter = NFXJson2Codable()
            if let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                let _ = converter.convertToCodable(
                    name: converter.getResourceName(from: model.requestURL),
                    from: dictionary
                )
                self.textViewCodable.textStorage?.setAttributedString(NSAttributedString(string: converter.printClasses()))
            } else if let array = try JSONSerialization.jsonObject(with: data) as? [Any], !array.isEmpty {
                let _ = converter.convertToCodable(
                    name: converter.getResourceName(from: model.requestURL),
                    from: array
                )
                self.textViewCodable.textStorage?.setAttributedString(NSAttributedString(string: converter.printClasses()))
            }
        } catch {
            self.textViewCodable.textStorage?.setAttributedString(NSAttributedString(string: "Something went wrong with decoding. :("))
        }
    }
}

#endif
