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


@objc public class NFXHTTPModel: NSObject {
    @objc public var requestURL: String?
    @objc public var requestURLComponents: URLComponents?
    @objc public var requestURLQueryItems: [URLQueryItem]?
    @objc public var requestMethod: String?
    @objc public var requestCachePolicy: String?
    @objc public var requestDate: Date?
    @objc public var requestTime: String?
    @objc public var requestTimeout: String?
    @objc public var requestHeaders: [AnyHashable: Any]?
    public var requestBodyLength: Int?
    @objc public var requestType: String?
    @objc public var requestCurl: String?

    public var responseStatus: Int?
    @objc public var responseType: String?
    @objc public var responseDate: Date?
    @objc public var responseTime: String?
    @objc public var responseHeaders: [AnyHashable: Any]?
    public var responseBodyLength: Int?
    
    public var timeInterval: Float?
    
    @objc public lazy var randomHash = UUID().uuidString
    public var shortType = HTTPModelShortType.OTHER
    @objc public var shortTypeString: String { return shortType.rawValue }
    
    @objc public var noResponse = true
    
    func saveRequest(_ request: URLRequest) {
        requestDate = Date()
        requestTime = getTimeFromDate(requestDate!)
        requestURL = request.getNFXURL()
        requestURLComponents = request.getNFXURLComponents()
        requestURLQueryItems = request.getNFXURLComponents()?.queryItems
        requestMethod = request.getNFXMethod()
        requestCachePolicy = request.getNFXCachePolicy()
        requestTimeout = request.getNFXTimeout()
        requestHeaders = request.getNFXHeaders()
        requestType = requestHeaders?["Content-Type"] as! String?
        requestCurl = request.getCurl()
    }
    
    func saveRequestBody(_ request: URLRequest) {
        saveRequestBodyData(request.getNFXBody())
    }
    
    func logRequest(_ request: URLRequest) {
        formattedRequestLogEntry().appendToFileURL(NFXPath.sessionLogURL)
    }
    
    func saveErrorResponse() {
        responseDate = Date()
    }
    
    func saveResponse(_ response: URLResponse, data: Data) {
        noResponse = false
        responseDate = Date()
        responseTime = getTimeFromDate(responseDate!)
        responseStatus = response.getNFXStatus()
        responseHeaders = response.getNFXHeaders()
        
        let headers = response.getNFXHeaders()
        
        if let contentType = headers["Content-Type"] as? String {
            let responseType = contentType.components(separatedBy: ";")[0]
            shortType = HTTPModelShortType(contentType: responseType)
            self.responseType = responseType
        }
        
        timeInterval = Float(responseDate!.timeIntervalSince(requestDate!))
        
        saveResponseBodyData(data)
        formattedResponseLogEntry().appendToFileURL(NFXPath.sessionLogURL)
    }
    
    func saveRequestBodyData(_ data: Data) {
        let tempBodyString = String.init(data: data, encoding: String.Encoding.utf8)
        self.requestBodyLength = data.count
        if (tempBodyString != nil) {
            saveData(tempBodyString!, to: getRequestBodyFileURL())
        }
    }
    
    func saveResponseBodyData(_ data: Data) {
        var bodyString: String?
        
        if shortType == .IMAGE {
            bodyString = data.base64EncodedString(options: .endLineWithLineFeed)

        } else {
            if let tempBodyString = String(data: data, encoding: String.Encoding.utf8) {
                bodyString = tempBodyString
            }
        }
        
        if let bodyString = bodyString {
            responseBodyLength = data.count
            saveData(bodyString, to: getResponseBodyFileURL())
        }
        
    }
    
    fileprivate func prettyOutput(_ rawData: Data, contentType: String? = nil) -> String {
        guard let contentType = contentType,
              let output = prettyPrint(rawData, type: .init(contentType: contentType))
        else {
            return String(data: rawData, encoding: String.Encoding.utf8) ?? ""
        }
        
        return output
    }

    @objc public func getRequestBody() -> String {
        guard let data = readRawData(from: getRequestBodyFileURL()) else {
            return ""
        }
        return prettyOutput(data, contentType: requestType)
    }
    
    @objc public func getResponseBody() -> String {
        guard let data = readRawData(from: getResponseBodyFileURL()) else {
            return ""
        }
        
        return prettyOutput(data, contentType: responseType)
    }
    
    @objc public func getRequestBodyFileURL() -> URL {
        return NFXPath.pathURLToFile(getRequestBodyFilename())
    }
    
    @objc public func getRequestBodyFilename() -> String {
        return "request_body_\(requestTime!)_\(randomHash)"
    }
    
    @objc public func getResponseBodyFileURL() -> URL {
        return NFXPath.pathURLToFile(getResponseBodyFilename())
    }
    
    @objc public func getResponseBodyFilename() -> String {
        return "response_body_\(requestTime!)_\(randomHash)"
    }
    
    @objc public func saveData(_ dataString: String, to fileURL: URL) {
        do {
            try dataString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch let error {
            print("[NFX]: Failed to save data to [\(fileURL)] - \(error.localizedDescription)")
        }
    }
    
    @objc public func readRawData(from fileURL: URL) -> Data? {
        do {
            return try Data(contentsOf: fileURL)
        } catch let error {
            print("[NFX]: Failed to load data from [\(fileURL)] - \(error.localizedDescription)")
            return nil
        }
    }
    
    @objc public func getTimeFromDate(_ date: Date) -> String? {
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
    
    public func prettyPrint(_ rawData: Data, type: HTTPModelShortType) -> String? {
        switch type {
        case .JSON:
            do {
                let rawJsonData = try JSONSerialization.jsonObject(with: rawData, options: [])
                let prettyPrintedString = try JSONSerialization.data(withJSONObject: rawJsonData, options: [.prettyPrinted])
                return String(data: prettyPrintedString, encoding: String.Encoding.utf8)
            } catch {
                return nil
            }
        default:
            return nil
        }
    }
    
    @objc public func isSuccessful() -> Bool {
        if (self.responseStatus != nil) && (self.responseStatus < 400) {
            return true
        } else {
            return false
        }
    }
    
    
    @objc public func formattedRequestLogEntry() -> String {
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
    
    @objc public func formattedResponseLogEntry() -> String {
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
