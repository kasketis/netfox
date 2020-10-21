//
//  NFXDetailsController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class NFXDetailsController: NFXGenericController {

    enum EDetailsView
    {
        case info
        case request
        case response
        case encrypted
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func getInfoStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
        tempString += "[URL] \n\(object.requestURL!)\n\n"
        tempString += "[Method] \n\(object.requestMethod!)\n\n"
        if !(object.noResponse) {
            tempString += "[Status] \n\(object.responseStatus!)\n\n"
        }
        tempString += "[Request date] \n\(object.requestDate!)\n\n"
        if !(object.noResponse) {
            tempString += "[Response date] \n\(object.responseDate!)\n\n"
            tempString += "[Time interval] \n\(object.timeInterval!)\n\n"
        }
        tempString += "[Timeout] \n\(object.requestTimeout!)\n\n"
        tempString += "[Cache policy] \n\(object.requestCachePolicy!)\n\n"
        
        return formatNFXString(tempString)
    }

    func getRequestStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
        tempString += "-- Headers --\n\n"
        
        if object.requestHeaders?.count > 0 {
            for (key, val) in (object.requestHeaders)! {
                tempString += "[\(key)] \n\(val)\n\n"
            }
        } else {
            tempString += "Request headers are empty\n\n"
        }
        
    #if os(iOS)
        tempString += getRequestBodyStringFooter(object)
    #endif
        return formatNFXString(tempString)
    }

    func getRequestBodyStringFooter(_ object: NFXHTTPModel) -> String {
        var tempString = "\n-- Body --\n\n"
        if (object.requestBodyLength == 0) {
            tempString += "Request body is empty\n"
        } else if (object.requestBodyLength > 1024) {
            tempString += "Too long to show. If you want to see it, please tap the following button\n"
        } else {
            tempString += "\(object.getRequestBody())\n"
        }
        return tempString
    }
    
    func getResponseStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString
    {
        if (object.noResponse) {
            return NSMutableAttributedString(string: "No response")
        }
        
        var tempString: String
        tempString = String()
        
        tempString += "-- Headers --\n\n"
        
        if object.responseHeaders?.count > 0 {
            for (key, val) in object.responseHeaders! {
                tempString += "[\(key)] \n\(val)\n\n"
            }
        } else {
            tempString += "Response headers are empty\n\n"
        }
        
        
    #if os(iOS)
        tempString += getResponseBodyStringFooter(object)
    #endif
        return formatNFXString(tempString)
    }
    
    func getResponseBodyStringFooter(_ object: NFXHTTPModel) -> String {
        var tempString = "-- Body --\n\n"
        if (object.responseBodyLength == 0) {
            tempString += "Response body is empty\n"
        } else if (object.responseBodyLength > 1024) {
            tempString += "Too long to show. If you want to see it, please tap the following button\n"
        } else {
            tempString += "\(object.getResponseBody())\n"
        }
        return tempString
    }
    
    
    func getEncryptedStringFromObject(_ object: NFXHTTPModel) -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
//        var toEncode: String
//        var encodedString: String
//        var decodedString: String
        
        tempString += "ENCRYPTED RESPONSE \n\n"
        let toEncode = object.getResponseBody() as String
        let encodedString = toEncode.toBase64()
        tempString += "\(encodedString)\n\n\n\n"
        
        let decodedString = encodedString.fromBase64()!
        tempString += "DECRYPTED RESPONSE \n\n"
        tempString += "\(decodedString)\n\n"
        
        return formatNFXString(tempString)
    }
}


extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
