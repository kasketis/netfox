//
//  NFXServer.swift
//  netfox_ios
//
//  Created by Alexandru Tudose on 01/11/2017.
//  Copyright © 2017 kasketis. All rights reserved.
//

import Foundation
import Swifter

public class NFXServer: NSObject {
    public struct Options {
        public static let bonjourServiceType = "_NFX._tcp."
        public static let port: UInt16 = 9999
        public static let allRequests = "allRequests"
        public static let allRequestsHtml = "allRequests.html"
    }
    
    var httpServer: HttpServer?
    var netService: NetService?
    var port: UInt16 = Options.port
    var numberOfRetries = 0
    
    public func startServer() {
        let server = HttpServer()
        server["/\(NFXServer.Options.allRequests)"] = {r in
            return HttpResponse.raw(200, "OK", ["Content-Type": "application/json"], {
                let models = NFXHTTPModelManager.sharedInstance.getModels().map({ $0.toJSON() })
                let jsonData = try! JSONSerialization.data(withJSONObject: models, options: [.prettyPrinted])
                try $0.write(jsonData)
            })
        }
        
        server["/\(NFXServer.Options.allRequestsHtml)"] = { _ in
            let models = NFXHTTPModelManager.sharedInstance.getModels()
            let stringModels = models.map({ $0.formattedRequestLogEntry() }).joined(separator: "\n")
            return .ok(.html(stringModels))
        }
        
        server["/hello"] = { .ok(.html("You asked for \($0)"))  }
        
        do {
            try server.start(port)
            print("Netfox server started on port: \(port) ")
            print("You can find what http calls are made using: GET http://localhost:\(port)/\(Options.allRequests)")
            print("Or start netfox mac app!")
            self.httpServer = server
            
            publishHttpService()
        } catch (let error) {
            print("Failed to start server on port: \(port) ", error)
            if numberOfRetries < 3 {
                port += 1 // retry on next port
                numberOfRetries += 1
                startServer()
            }
        }
    }
    
    public func stopServer() {
        httpServer?.stop()
        httpServer = nil
        
        netService?.stop()
        netService = nil
    }
    
    func publishHttpService() {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        let netService = NetService(domain: "", type: NFXServer.Options.bonjourServiceType, name: "", port: Int32(port))
        netService.delegate = self
        netService.publish()
        self.netService = netService
    }
}

extension NFXServer: NetServiceDelegate {
    public func netServiceDidPublish(_ sender: NetService) {
    }
    
    public func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("failed to publish http service: \(errorDict)")
    }
}

extension NFX {
    public func addJSONModels(_ data: Data) {
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        if let jsonModels = json as? [[String: Any]] {
            let models: [NFXHTTPModel] = jsonModels.flatMap({
                let model = NFXHTTPModel()
                model.fromJSON(json: $0)
                return model
            })
            
            models.forEach({ NFXHTTPModelManager.sharedInstance.add($0) })
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NFXReloadData"), object: nil)
        }
    }
}
