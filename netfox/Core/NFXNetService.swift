//
//  NFXNetService.swift
//  netfox_mac
//
//  Created by Alexandru Tudose on 01/11/2017.
//  Copyright © 2017 kasketis. All rights reserved.
//

import Foundation

#if os(OSX)
class NFXNetService: NSObject {
    
    static let shared = NFXNetService()
    
    var foundServices: [(service: NetService, address: String)] = []
    var processingServices: [NetService] = []
    let serviceBrowser = NetServiceBrowser()
    
    var clients: [NFXClientConnection] = []
    
    func browseForAvailableNFXServices() {
        windowController?.popupButton.removeAllItems()
        
        serviceBrowser.delegate = self
        serviceBrowser.searchForServices(ofType: NFXServer.Options.bonjourServiceType, inDomain: "")
    }
    
    func foundServer(address: String, service: NetService) {
        if foundServices.isEmpty {
            fetchServiceContent(service: service)
        }
        
        foundServices.append((service: service, address: address))
        windowController?.popupButton.addItem(withTitle: service.name + " " + (service.hostName ?? "") )
    }
    
    func removeService(_ service: NetService) {
        if let index = foundServices.index(where: { $0.service === service }) {
            foundServices.remove(at: index)
            windowController?.popupButton.removeItem(at: index)
        }
    }
    
    var windowController: NFXWindowController? {
        return NFX.sharedInstance().windowController
    }
    
    func fetchServiceContent(service: NetService) {
        NFXHTTPModelManager.sharedInstance.clear()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NFXReloadData"), object: nil)
        
        var inputStream: InputStream?
        var outputStream: OutputStream?
        let didOpen = service.getInputStream(&inputStream, outputStream: &outputStream)
        if didOpen {
            let client = NFXClientConnection(inputStream: inputStream!, outputStream: outputStream!)
            client.scheduleOnBackgroundRunLoop()
            client.prepareForReadingStream()
            clients.forEach({ $0.stopRunLoop() })
            clients = [client]
            client.onClose = { [unowned self] in
                self.clients = []
                self.removeService(service)
            }
        }
    }
}


extension NFXNetService: NetServiceBrowserDelegate {
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self
        service.resolve(withTimeout: 0)
        processingServices.append(service)
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print(#function)
    }
}

extension NFXNetService: NetServiceDelegate {
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("Found service: \(sender.hostName ?? "") \(sender)")
        
        let addresses = sender.addresses?.flatMap({ (data: Data) -> String? in
            let nsData = data as NSData
            let inetAddress: sockaddr_in = nsData.castToCPointer()
            if inetAddress.sin_family == __uint8_t(AF_INET) {
                return String(cString: inet_ntoa(inetAddress.sin_addr), encoding: .ascii)
            } else {
                return nil
            }
        })
        
        if let address = addresses?.first {
            self.foundServer(address: address, service: sender)
        }
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("failed to resove service \(sender): \(errorDict)")
    }
}



extension NSData {
    func castToCPointer<T>() -> T {
        let mem = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T.Type>.size)
        self.getBytes(mem, length: MemoryLayout<T.Type>.size)
        return mem.move()
    }
}
    


#endif
