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
        public static let port: UInt16 = 12222
        public static let allRequests = "allRequests"
        public static let allRequestsHtml = "allRequests.html"
    }
    
    var httpServer: HttpServer?
    var netService: NetService?
    var port: UInt16 = Options.port
    var numberOfRetries = 0
    var connectedClients: [NFXClientConnection] = []
    
    public func startServer() {
//        let server = HttpServer()
//        server["/\(NFXServer.Options.allRequests)"] = {r in
//            return HttpResponse.raw(200, "OK", ["Content-Type": "application/json"], {
//                let models = NFXHTTPModelManager.sharedInstance.getModels().map({ $0.toJSON() })
//                let jsonData = try! JSONSerialization.data(withJSONObject: models, options: [.prettyPrinted])
//                try $0.write(jsonData)
//            })
//        }
//
//        server["/\(NFXServer.Options.allRequestsHtml)"] = { _ in
//            let models = NFXHTTPModelManager.sharedInstance.getModels()
//            let stringModels = models.map({ $0.formattedRequestLogEntry() }).joined(separator: "\n")
//            return .ok(.html(stringModels))
//        }
//
//        server["/hello"] = { .ok(.html("You asked for \($0)"))  }
//
//        do {
//            try server.start(port)
//            print("Netfox server started on port: \(port) ")
//            print("You can find what http calls are made using: GET http://localhost:\(port)/\(Options.allRequests)")
//            print("Or start netfox mac app!")
//            self.httpServer = server
            publishHttpService()
//        } catch (let error) {
//            print("Failed to start server on port: \(port) ", error)
//            if numberOfRetries < 3 {
//                port += 1 // retry on next port
//                numberOfRetries += 1
//                startServer()
//            }
//        }
    }
    
    public func stopServer() {
        httpServer?.stop()
        httpServer = nil
        
        netService?.stop()
        netService = nil
    }
    
    func publishHttpService() {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        let netService = NetService(domain: "", type: NFXServer.Options.bonjourServiceType, name: bundleIdentifier, port: Int32(port + 1))
        netService.delegate = self
        netService.publish(options: [.listenForConnections])
        self.netService = netService
    }
    
    func broadcastModel(_ model: NFXHTTPModel) {
        connectedClients.forEach({ $0.writeModel(model) })
    }
}

extension NFXServer: NetServiceDelegate {
    public func netServiceDidPublish(_ sender: NetService) {
        
    }
    
    public func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("failed to publish http service: \(errorDict)")
    }
    
    public func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream) {
        let client = NFXClientConnection(inputStream: inputStream, outputStream: outputStream)
        client.scheduleOnMainRunLoop()
        connectedClients.append(client)
        client.writeAllModels()
    }
}

extension NFX {
    public func addJSONModels(_ data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return
        }
        
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
