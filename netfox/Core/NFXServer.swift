//
//  NFXServer.swift
//  netfox_ios
//
//  Created by Alexandru Tudose on 01/11/2017.
//  Copyright © 2017 kasketis. All rights reserved.
//

import Foundation

public class NFXServer: NSObject {
    public struct Options {
        public static let bonjourServiceType = "_NFX._tcp."
        public static let port: UInt16 = 12222
    }
    
    var netService: NetService?
    var port: UInt16 = Options.port
    var numberOfRetries = 0
    var connectedClients: [NFXClientConnection] = []
    
    public func startServer() {
        publishHttpService()
        #if os(iOS)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        #endif
    }
    
    public func stopServer() {
        netService?.stop()
        netService = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func publishHttpService() {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        let netService = NetService(domain: "", type: NFXServer.Options.bonjourServiceType, name: bundleIdentifier, port: Int32(port))
        netService.delegate = self
        netService.publish(options: [.listenForConnections])
        self.netService = netService
    }
    
    func broadcastModel(_ model: NFXHTTPModel) {
        connectedClients.forEach({ $0.writeModel(model) })
    }
    
    @objc func applicationDidBecomeActive() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.connectedClients.isEmpty {
                self.stopServer()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.startServer()
                }
            }
        }
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
        client.scheduleOnBackgroundRunLoop()
        connectedClients.append(client)
        client.prepareForWritingStream()
        client.writeAllModels()
        client.onClose = { [unowned self] in
            if let index = self.connectedClients.index(of: client) {
                self.connectedClients.remove(at: index)
            }
        }
    }
}

