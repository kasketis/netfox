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
    
    var randomHash: String?
    
    var shortType: String = HTTPModelShortType.OTHER.rawValue
    
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
        
        let httpResponse = response as! HTTPURLResponse
        if let contentType = httpResponse.allHeaderFields["Content-Type"] as? String
        //if let contentType = self.responseHeaders.subscript(key: "Content-Type") as? String
        {
            self.responseType = contentType.components(separatedBy: ";")[0]
            self.shortType = getShortTypeFrom(self.responseType!).rawValue
        }
        
        self.timeInterval = Float(self.responseDate!.timeIntervalSince(self.requestDate!))
        
        saveResponseBodyData(data)
    }
    
    func saveRequestBodyData(_ data: Data)
    {
        let tempBodyString = NSString.init(data: data,
                                           encoding: String.Encoding.utf8.rawValue)
        self.requestBodyLength = data.count
        if (tempBodyString != nil)
        {
            saveData(tempBodyString!, toFile: getRequestBodyFilepath())
            saveAllData(data, toFile: getFullLogFilepath(),
                        isResponse: false)
        }
    }
    
    func saveResponseBodyData(_ data: Data)
    {
        var bodyString: String?
        
        if self.shortType == HTTPModelShortType.IMAGE.rawValue
        {
            bodyString = data.base64EncodedString(options: [.endLineWithLineFeed])
        }
        else
        {
            if let tempBodyString = NSString.init(data: data,
                                                  encoding: String.Encoding.utf8.rawValue)
            {
                bodyString = tempBodyString as String
            }
        }
        
        if (bodyString != nil)
        {
            self.responseBodyLength = data.count
            saveData(bodyString! as NSString,
                     toFile: getResponseBodyFilepath())
            
            saveAllData(data, toFile: getFullLogFilepath(),
                        isResponse: true)
        }
    }
    
    private func prettyOutput(_ rawData: Data, contentType: String? = nil) -> String
    {
        if let contentType = contentType
        {
            let shortType = getShortTypeFrom(contentType)
            if let output = prettyPrint(rawData, type: shortType)
            {
                return output
            }
        }
        
        return (NSString(data: rawData,
                         encoding: String.Encoding.utf8.rawValue) ?? "") as String
    }

    // MARK: - File Access
    func getRequestBody() -> String
    {
        guard let data = readRawData(getRequestBodyFilepath()) else
        {
            return ""
        }
        
        return prettyOutput(data, contentType: requestType)
    }
    
    func getResponseBody() -> String
    {
        guard let data = readRawData(getResponseBodyFilepath()) else
        {
            return ""
        }
        
        return prettyOutput(data, contentType: responseType)
    }
    
    func getRandomHash() -> String
    {
        if !(self.randomHash != nil)
        {
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
        return String("nfx_request_body_") +
            "\(self.requestTime!)_\(getRandomHash() as String)"
    }
    
    func getResponseBodyFilepath() -> String
    {
        let dir = getDocumentsPath() as NSString
        return dir.appendingPathComponent(getResponseBodyFilename())
    }
    
    func getResponseBodyFilename() -> String
    {
        return String("nfx_response_body_") +
            "\(self.requestTime!)_\(getRandomHash() as String)"
    }
    
    func getFullLogFilepath() -> String
    {
        let dir = getDocumentsPath() as NSString
        return dir.appendingPathComponent(getFullLogFilename())
    }

    func getFullLogFilename() -> String
    {
        return String("nfx_complete_log.txt")
    }
    
    func getDocumentsPath() -> String
    {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                   FileManager.SearchPathDomainMask.allDomainsMask, true).first!
    }
    
    // MARK: - Disk Access
    func saveAllData(_ rawData: Data, toFile: String, isResponse: Bool)
    {
        var dataString: String
        dataString = String()

        dataString = self.createInfoString()
        if (isResponse)
        {
            dataString += self.createResponseString(rawData)
        }
        else
        {
            dataString += self.createRequestString(rawData)
        }
        
        let fileurl = NSURL.fileURL(withPath: toFile)
        let theData = dataString.data(using: String.Encoding.utf8,
                                      allowLossyConversion: false)!
        
        if FileManager.default.fileExists(atPath: fileurl.path)
        {
            do
            {
                let fileHandle = try FileHandle(forWritingTo: fileurl)
                fileHandle.seekToEndOfFile()
                fileHandle.write(theData)
                fileHandle.closeFile()
            }
            catch
            {
                print("Can't open fileHandle \(error)")
            }
        }
        else
        {
            do
            {
                try dataString.write(toFile: toFile,
                                     atomically: false,
                                     encoding: String.Encoding.utf8)
            } catch {}
        }
    }
    
    
    func saveData(_ dataString: NSString, toFile: String)
    {
        do
        {
            try dataString.write(toFile: toFile,
                                 atomically: false,
                                 encoding: String.Encoding.utf8.rawValue)
        } catch {}
    }
    
    func readRawData(_ fromFile: String) -> Data?
    {
        return (try? Data(contentsOf: URL(fileURLWithPath: fromFile)))
    }
    
    // MARK:
    func getTimeFromDate(_ date: Date) -> String
    {
        var timeString = "??:??"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute],
                                                 from: date)
        
        let hour = components.hour!
        let minutes = components.minute!
        if minutes < 10
        {
            timeString = "\(hour):0\(minutes)"
        }
        else
        {
            timeString = "\(hour):\(minutes)"
        }
    
        return timeString
    }
    
    func getShortTypeFrom(_ contentType: String) -> HTTPModelShortType
    {
        if contentType == "application/json"
        {
            return .JSON
        }
        
        if (contentType == "application/xml") ||
            (contentType == "text/xml")
        {
            return .XML
        }
        
        if contentType == "text/html"
        {
            return .HTML
        }
        
        if contentType.hasPrefix("image/")
        {
            return .IMAGE
        }
        
        return .OTHER
    }
    
    func prettyPrint(_ rawData: Data, type: HTTPModelShortType) -> String?
    {
        switch type {
        case .JSON:
            do
            {
                let rawJsonData = try JSONSerialization.jsonObject(with: rawData, options: [])
                let prettyPrintedString = try JSONSerialization.data(withJSONObject: rawJsonData,
                                                                     options: [.prettyPrinted])
                return NSString(data: prettyPrintedString,
                                encoding: String.Encoding.utf8.rawValue) as? String
            }
            catch
            {
                return nil
            }
        
        default:
            return nil
            
        }
    }
    
    func isSuccessful() -> Bool
    {
        if (self.responseStatus != nil) && (self.responseStatus! < 400)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    // MARK:
    func createInfoString() -> String
    {
        var tempString: String
        tempString = String()
        
        tempString += "[URL] \(self.requestURL!)\n"
        tempString += "*********************************************************\n"
        tempString += "[Method] \(self.requestMethod!)\n"
        if !(self.noResponse)
        {
            tempString += "[Status] \(self.responseStatus!)\n"
        }
        
        tempString += "[Request date] \(self.requestDate!)\n"
        if !(self.noResponse)
        {
            tempString += "[Response date] \(self.responseDate!)\n"
            tempString += "[Time interval] \(self.timeInterval!)\n"
        }
        tempString += "[Timeout] \(self.requestTimeout!)\n"
        tempString += "[Cache policy] \(self.requestCachePolicy!)\n"
        
        return tempString
    }
    
    func createRequestString(_ rawData: Data) -> String
    {
        var tempString: String
        tempString = String()
        
        tempString += "=====================\n-- Request Headers --\n=====================\n"
        if (self.requestHeaders?.count)! > 0
        {
            for (key, val) in (self.requestHeaders)!
            {
                tempString += "[\(key)] \(val)\n"
            }
        }
        else
        {
            tempString += "Request headers are empty\n"
        }
        
        tempString += "===========\n-- Body --\n===========\n"
        if (self.requestBodyLength == 0)
        {
            tempString += "Request body is empty\n"
        }
        else
        {
            tempString += "\(self.prettyOutput(rawData, contentType: self.requestType))\n"
        }
        
        tempString += "*********************************************************\n"
        return tempString
    }
    
    func createResponseString(_ rawData: Data) -> String
    {
        var tempString: String
        tempString = String()
        
        if (self.noResponse)
        {
            tempString += "=================\n-- No Response --\n==================\n"
        }
        else
        {
            tempString += "======================\n-- Response Headers --\n======================\n"
            if (self.responseHeaders?.count)! > 0
            {
                for (key, val) in self.responseHeaders!
                {
                    tempString += "[\(key)] \(val)\n"
                }
            }
            else
            {
                tempString += "Response headers are empty\n"
            }
            
            tempString += "===========\n-- Body --\n===========\n"
            if (self.responseBodyLength == 0)
            {
                tempString += "Response body is empty\n"
            }
            else
            {
                tempString += "\(self.prettyOutput(rawData, contentType: self.responseType))\n"
            }
        }
        tempString += "*********************************************************\n"
        return tempString
    }

}
