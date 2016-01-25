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
        
        if let url = request.URL {
            if (!(url.absoluteString.hasPrefix("http")) && !(url.absoluteString.hasPrefix("https"))) {
                return false
            }

            for ignoredURL in NFX.sharedInstance().getIgnoredURLs() {
                if url.absoluteString.hasPrefix(ignoredURL) {
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
            
            if let error = error {
                self.model?.saveErrorResponse()
                self.loaded()
                self.client?.URLProtocol(self, didFailWithError: error)
            } else {
                if let
                    data = data,
                    response = response {
                    self.model?.saveResponse(response, data: data)
                }
                self.loaded()
            }
            
            if let response = response {
                self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
            }
            
            if let data = data {
                self.client?.URLProtocol(self, didLoadData: data)
            }
            
            self.client?.URLProtocolDidFinishLoading(self)

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
