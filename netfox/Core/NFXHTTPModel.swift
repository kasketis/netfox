//
//  NFXHTTPModel.swift
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


class NFXHTTPModel: NSObject
{
    var requestURL: String?
    var requestMethod: String?
    var requestCachePolicy: String?
    var requestDate: Date?
    var requestTime: String?
    var requestTimeout: String?
    var requestHeaders: [AnyHashable: Any]?
    var requestBodyLength: Int?
    var requestType: String?
    
    var responseStatus: Int?
    var responseType: String?
    var responseDate: Date?
    var responseTime: String?
    var responseHeaders: [AnyHashable: Any]?
    var responseBodyLength: Int?
    
    var timeInterval: Float?
    
    var randomHash: NSString?
    
    @objc var shortType: NSString = HTTPModelShortType.OTHER.rawValue as NSString
    
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
        self.requestType = requestHeaders?["Content-Type"] as! String?
        saveRequestBodyData(request.getNFXBody())
        formattedRequestLogEntry().appendToFile(filePath: NFXPath.SessionLog)

    }
    
    func saveErrorResponse()
    {
        self.responseDate = Date()
    }
    
    func saveResponse(_ response: URLResponse, data: Data)
    {
        self.noResponse = false
        
        self.responseDate = Date()
        self.responseTime = getTimeFromDate(self.responseDate!)
        self.responseStatus = response.getNFXStatus()
        self.responseHeaders = response.getNFXHeaders()
        
        let headers = response.getNFXHeaders()
        
        if let contentType = headers["Content-Type"] as? String {
            self.responseType = contentType.components(separatedBy: ";")[0]
            self.shortType = getShortTypeFrom(self.responseType!).rawValue as NSString
        }
        
        self.timeInterval = Float(self.responseDate!.timeIntervalSince(self.requestDate!))
        
        saveResponseBodyData(data)
        formattedResponseLogEntry().appendToFile(filePath: NFXPath.SessionLog)
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
        
        if self.shortType as String == HTTPModelShortType.IMAGE.rawValue {
            bodyString = data.base64EncodedString(options: .endLineWithLineFeed) as NSString?

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
    
    fileprivate func prettyOutput(_ rawData: Data, contentType: String? = nil) -> NSString
    {
        if let contentType = contentType {
            let shortType = getShortTypeFrom(contentType)
            if let output = prettyPrint(rawData, type: shortType) {
                return output as NSString
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
            self.randomHash = UUID().uuidString as NSString?
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
        } catch {
            print("catch !!!")
        }
    }
    
    func readRawData(_ fromFile: String) -> Data?
    {
        return (try? Data(contentsOf: URL(fileURLWithPath: fromFile)))
    }
    
    func getTimeFromDate(_ date: Date) -> String?
    {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute], from: date)
        guard let hour = components.hour, let minutes = components.minute else {
            return nil
        }
        if minutes < 10 {
            return "\(hour):0\(minutes)"
        } else {
            return "\(hour):\(minutes)"
        }
    }
    
    func getShortTypeFrom(_ contentType: String) -> HTTPModelShortType
    {
        if NSPredicate(format: "SELF MATCHES %@",
                                "^application/(vnd\\.(.*)\\+)?json$").evaluate(with: contentType) {
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
    
    func prettyPrint(_ rawData: Data, type: HTTPModelShortType) -> NSString?
    {
        switch type {
        case .JSON:
            do {
                let rawJsonData = try JSONSerialization.jsonObject(with: rawData, options: [])
                let prettyPrintedString = try JSONSerialization.data(withJSONObject: rawJsonData, options: [.prettyPrinted])
                return NSString(data: prettyPrintedString, encoding: String.Encoding.utf8.rawValue)
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
    
    
    func formattedRequestLogEntry() -> String {
        var log = String()
        
        if let requestURL = self.requestURL {
            log.append("-------START REQUEST -  \(requestURL) -------\n")
        }

        if let requestMethod = self.requestMethod {
            log.append("[Request Method] \(requestMethod)\n")
        }
        
        if let requestDate = self.requestDate {
            log.append("[Request Date] \(requestDate)\n")
        }
        
        if let requestTime = self.requestTime {
            log.append("[Request Time] \(requestTime)\n")
        }
        
        if let requestType = self.requestType {
            log.append("[Request Type] \(requestType)\n")
        }
            
        if let requestTimeout = self.requestTimeout {
            log.append("[Request Timeout] \(requestTimeout)\n")
        }
            
        if let requestHeaders = self.requestHeaders {
            log.append("[Request Headers]\n\(requestHeaders)\n")
        }
        
        log.append("[Request Body]\n \(getRequestBody())\n")
        
        if let requestURL = self.requestURL {
            log.append("-------END REQUEST - \(requestURL) -------\n\n")
        }
        
        return log;
    }
    
    func formattedResponseLogEntry() -> String {
        var log = String()
        
        if let requestURL = self.requestURL {
            log.append("-------START RESPONSE -  \(requestURL) -------\n")
        }
        
        if let responseStatus = self.responseStatus {
            log.append("[Response Status] \(responseStatus)\n")
        }
        
        if let responseType = self.responseType {
            log.append("[Response Type] \(responseType)\n")
        }
        
        if let responseDate = self.responseDate {
            log.append("[Response Date] \(responseDate)\n")
        }
        
        if let responseTime = self.responseTime {
            log.append("[Response Time] \(responseTime)\n")
        }
        
        if let responseHeaders = self.responseHeaders {
            log.append("[Response Headers]\n\(responseHeaders)\n\n")
        }
        
        log.append("[Response Body]\n \(getResponseBody())\n")
        
        if let requestURL = self.requestURL {
            log.append("-------END RESPONSE - \(requestURL) -------\n\n")
        }
        
        return log;
    }

}
