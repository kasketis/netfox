//
//  NFXHTTPModel.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation

class NFXHTTPModel: NSObject
{
    var requestURL: String?
    var requestMethod: String?
    var requestCachePolicy: String?
    var requestDate: Date?
    var requestTime: String?
    var requestTimeout: String?
    var requestHeaders: Dictionary<String, String>?
    var requestBodyLength: Int?
    var requestType: String?
    
    var responseStatus: Int?
    var responseType: String?
    var responseDate: Date?
    var responseTime: String?
    var responseHeaders: Dictionary<NSObject, AnyObject>?
    var responseBodyLength: Int?
    
    var timeInterval: Float?
    
    var randomHash: NSString?
    
    var shortType: NSString = HTTPModelShortType.OTHER.rawValue
    
    var noResponse: Bool = true
    
    func saveRequest(_ request: URLRequest)
    {
        self.requestDate = Date()
        self.requestTime = getTimeFromDate(self.requestDate!)
        self.requestURL = request.getNFXURL()
        self.requestMethod = request.getNFXMethod()
        self.requestCachePolicy = request.getNFXCachePolicy()
        self.requestTimeout = request.getNFXTimeout()
        self.requestHeaders = request.getNFXHeaders()
        self.requestType = requestHeaders?["Content-Type"]
        saveRequestBodyData(request.getNFXBody())
    }
    
    func saveResponse(_ response: URLResponse, data: Data)
    {
        self.noResponse = false
        
        self.responseDate = Date()
        self.responseTime = getTimeFromDate(self.responseDate!)
        self.responseStatus = response.getNFXStatus()
        self.responseHeaders = response.getNFXHeaders()
        
        if let contentType = response.getNFXHeaders()["Content-Type"] as? String {
            self.responseType = contentType.components(separatedBy: ";")[0]
            self.shortType = getShortTypeFrom(self.responseType!).rawValue
        }
        
        self.timeInterval = Float(self.responseDate!.timeIntervalSince(self.requestDate!))
        
        saveResponseBodyData(data)

    }
    
    
    func saveRequestBodyData(_ data: Data)
    {
        let tempBodyString = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue)
        self.requestBodyLength = data.count
        if (tempBodyString != nil) {
            saveData(tempBodyString!, toFile: getRequestBodyFilepath())
        }
    }
    
    func saveResponseBodyData(_ data: Data)
    {
        var bodyString: NSString?
        
        if self.shortType == HTTPModelShortType.IMAGE.rawValue {
            bodyString = data.base64EncodedString(.encodingEndLineWithLineFeed)

        } else {
            if let tempBodyString = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) {
                bodyString = tempBodyString
            }
        }
        
        if (bodyString != nil) {
            self.responseBodyLength = data.count
            saveData(bodyString!, toFile: getResponseBodyFilepath())
        }
        
    }
    
    private func prettyOutput(_ rawData: Data, contentType: String? = nil) -> NSString
    {
        if let contentType = contentType {
            let shortType = getShortTypeFrom(contentType)
            if let output = prettyPrint(rawData, type: shortType) {
                return output
            }
        }
        return NSString(data: rawData, encoding: String.Encoding.utf8.rawValue) ?? ""
    }

    func getRequestBody() -> NSString
    {
        guard let data = readRawData(getRequestBodyFilepath()) else {
            return ""
        }
        return prettyOutput(data, contentType: requestType)
    }
    
    func getResponseBody() -> NSString
    {
        guard let data = readRawData(getResponseBodyFilepath()) else {
            return ""
        }
        
        return prettyOutput(data, contentType: responseType)
    }
    
    func getRandomHash() -> NSString
    {
        if !(self.randomHash != nil) {
            self.randomHash = UUID().uuidString
        }
        return self.randomHash!
    }
    
    func getRequestBodyFilepath() -> String
    {
        let dir = getDocumentsPath() as NSString
        return dir.appendingPathComponent(getRequestBodyFilename())
    }
    
    func getRequestBodyFilename() -> String
    {
        return String("nfx_request_body_") + "\(self.requestTime!)_\(getRandomHash() as String)"
    }
    
    func getResponseBodyFilepath() -> String
    {
        let dir = getDocumentsPath() as NSString
        return dir.appendingPathComponent(getResponseBodyFilename())
    }
    
    func getResponseBodyFilename() -> String
    {
        return String("nfx_response_body_") + "\(self.requestTime!)_\(getRandomHash() as String)"
    }
    
    func getDocumentsPath() -> String
    {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
    }
    
    func saveData(_ dataString: NSString, toFile: String)
    {
        do {
            try dataString.write(toFile: toFile, atomically: false, encoding: String.Encoding.utf8.rawValue)
        } catch {}
    }
    
    func readRawData(_ fromFile: String) -> Data?
    {
        return (try? Data(contentsOf: URL(fileURLWithPath: fromFile)))
    }
    
    func getTimeFromDate(_ date: Date) -> String
    {
        let calendar = Calendar.current()
        let components = calendar.components([.hour, .minute], from: date)
        let hour = components.hour
        let minutes = components.minute
        if minutes < 10 {
            return "\(hour):0\(minutes)"
        } else {
            return "\(hour):\(minutes)"
        }
    }
    
    func getShortTypeFrom(_ contentType: String) -> HTTPModelShortType
    {
        if contentType == "application/json" {
            return .JSON
        }
        
        if (contentType == "application/xml") || (contentType == "text/xml")  {
            return .XML
        }
        
        if contentType == "text/html" {
            return .HTML
        }
        
        if contentType.hasPrefix("image/") {
            return .IMAGE
        }
        
        return .OTHER
    }
    
    func prettyPrint(_ rawData: Data, type: HTTPModelShortType) -> String?
    {
        switch type {
        case .JSON:
            do {
                let rawJsonData = try JSONSerialization.jsonObject(with: rawData, options: [])
                let prettyPrintedString = try JSONSerialization.data(withJSONObject: rawJsonData, options: [.prettyPrinted])
                return NSString(data: prettyPrintedString, encoding: String.Encoding.utf8.rawValue) as? String
            } catch {
                return nil
            }
        
        default:
            return nil
            
        }
    }
    
    func isSuccessful() -> Bool
    {
        if (self.responseStatus != nil) && (self.responseStatus < 400) {
            return true
        } else {
            return false
        }
    }
}
