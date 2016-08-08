//
//  NFXProtocol.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

@objc
public class NFXProtocol: NSURLProtocol
{
    var connection: NSURLConnection?
    var model: NFXHTTPModel?
    var session: NSURLSession?
    
    override public class func canInitWithRequest(request: NSURLRequest) -> Bool
    {
        return canServeRequest(request)
    }
    
    override public class func canInitWithTask(task: NSURLSessionTask) -> Bool
    {
        guard let request = task.currentRequest else { return false }
        return canServeRequest(request)
    }
    
    private class func canServeRequest(request: NSURLRequest) -> Bool
    {
        if !NFX.sharedInstance().isEnabled() {
            return false
        }
        
        if let url = request.URL?.absoluteString {
            if (!(url.hasPrefix("http")) && !(url.hasPrefix("https"))) {
                return false
            }

            for ignoredURL in NFX.sharedInstance().getIgnoredURLs() {
                if url.hasPrefix(ignoredURL) {
                    return false
                }
            }
            
        } else {
            return false
        }
        
        if NSURLProtocol.propertyForKey("NFXInternal", inRequest: request) != nil {
            return false
        }
        
        return true
    }
    
    override public func startLoading()
    {
        self.model = NFXHTTPModel()
                
        var req: NSMutableURLRequest
        req = NFXProtocol.canonicalRequestForRequest(request).mutableCopy() as! NSMutableURLRequest
        
        self.model?.saveRequest(req)
                
        NSURLProtocol.setProperty("1", forKey: "NFXInternal", inRequest: req)
        
        if (session == nil) {
            session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        }
        
        session!.dataTaskWithRequest(req, completionHandler: {data, response, error in
            
            if error != nil {
                self.model?.saveErrorResponse()
                self.loaded()
                self.client?.URLProtocol(self, didFailWithError: error!)
                
            } else {
                if ((data) != nil) {
                    self.model?.saveResponse(response!, data: data!)
                }
                self.loaded()
            }
            
            if (response != nil) {
                self.client!.URLProtocol(self, didReceiveResponse: response!, cacheStoragePolicy: .NotAllowed)
            }
            
            if (data != nil) {
                self.client!.URLProtocol(self, didLoadData: data!)
            }
            
            if let client = self.client {
                client.URLProtocolDidFinishLoading(self)
            }

        }).resume()
        

    }
    
    override public func stopLoading()
    {
        
    }
    
    override public class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest
    {
        return request
    }
        
    func loaded()
    {
        if (self.model != nil) {
            NFXHTTPModelManager.sharedInstance.add(self.model!)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("NFXReloadData", object: nil)
    }
    
}
