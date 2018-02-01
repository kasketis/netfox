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
    
    var netService: NetService?
    var port: UInt16 = Options.port
    var numberOfRetries = 0
    var connectedClients: [NFXClientConnection] = []
    
    public func startServer() {
        publishHttpService()
    }
    
    public func stopServer() {
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
        client.onClose = { [unowned self] in
            if let index = self.connectedClients.index(of: client) {
                self.connectedClients.remove(at: index)
            }
        }
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
