//
//  NFXProtocol.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

@objc
open class NFXProtocol: URLProtocol
{
    var connection: NSURLConnection?
    var model: NFXHTTPModel?
    var session: URLSession?
    
    override open class func canInit(with request: URLRequest) -> Bool
    {
        return canServeRequest(request)
    }
    
    override open class func canInit(with task: URLSessionTask) -> Bool
    {
        guard let request = task.currentRequest else { return false }
        return canServeRequest(request)
    }
    
    fileprivate class func canServeRequest(_ request: URLRequest) -> Bool
    {
        if !NFX.sharedInstance().isEnabled() {
            return false
        }
        
        if let url = request.url {
            if !(url.absoluteString.hasPrefix("http")) && !(url.absoluteString.hasPrefix("https")) {
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
        
        if URLProtocol.property(forKey: "NFXInternal", in: request) != nil {
            return false
        }
        
        return true
    }
    
    override open func startLoading()
    {
        self.model = NFXHTTPModel()
        
        var req: NSMutableURLRequest
        req = (NFXProtocol.canonicalRequest(for: request) as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        
        self.model?.saveRequest(req as URLRequest)
        
        URLProtocol.setProperty("1", forKey: "NFXInternal", in: req)
        
        if session == nil {
            session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        }
        
        session!.dataTask(with: req as URLRequest, completionHandler: {data, response, error in
            
            self.model?.saveRequestBody(req as URLRequest)
            self.model?.logRequest(req as URLRequest)
            
            if let error = error {
                self.model?.saveErrorResponse()
                self.loaded()
                self.client?.urlProtocol(self, didFailWithError: error)
                
            } else {
                if let data = data {
                    self.model?.saveResponse(response!, data: data)
                }
                self.loaded()
            }
            
            if let response = response, let client = self.client {
                client.urlProtocol(self, didReceive: response, cacheStoragePolicy: NFX.swiftSharedInstance.cacheStoragePolicy)
            }
            
            if let data = data {
                self.client!.urlProtocol(self, didLoad: data)
            }
            
            if let client = self.client {
                client.urlProtocolDidFinishLoading(self)
            }
        }).resume()
    }
    
    override open func stopLoading()
    {
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest
    {
        return request
    }
    
    func loaded()
    {
        if (self.model != nil) {
            NFXHTTPModelManager.sharedInstance.add(self.model!)
        }
        
        NotificationCenter.default.post(name: Notification.Name.NFXReloadData, object: nil)
    }
}

extension NFXProtocol : URLSessionDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let policy = URLCache.StoragePolicy(rawValue: request.cachePolicy.rawValue) ?? .notAllowed
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: policy)
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        if let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest {
            URLProtocol.removeProperty(forKey: "NFXInternal", in: mutableRequest)
            client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
            completionHandler(request)
        }
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        guard let error = error else { return }
        client?.urlProtocol(self, didFailWithError: error)
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let wrappedChallenge = URLAuthenticationChallenge(authenticationChallenge: challenge, sender: NFXAuthenticationChallengeSender(handler: completionHandler))
        client?.urlProtocol(self, didReceive: wrappedChallenge)
    }
    
    #if !os(OSX)
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        client?.urlProtocolDidFinishLoading(self)
    }
    #endif
}
