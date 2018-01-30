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
    struct ServerService {
        var inputStream: InputStream
        var outpuStream: OutputStream
    }
    
    static let shared = NFXNetService()
    
    var foundServices: [(service: NetService, address: String)] = []
    var processingServices: [NetService] = []
    let serviceBrowser = NetServiceBrowser()
    
    var services: [ServerService] = []
    
    func browseForAvailableNFXServices() {
        windowController?.popupButton.removeAllItems()
        
        serviceBrowser.delegate = self
        serviceBrowser.searchForServices(ofType: NFXServer.Options.bonjourServiceType, inDomain: "")
    }
    
    func foundServer(address: String, service: NetService) {
        if foundServices.isEmpty {
            loadAllRequests(address: address, port: service.port)
        }
        
        foundServices.append((service: service, address: address))
        windowController?.popupButton.addItem(withTitle: service.name + " " + (service.hostName ?? "") )
    }
    
    var windowController: NFXWindowController? {
        return NFX.sharedInstance().windowController
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
        
        var inputStream: InputStream?
        var outputStream: OutputStream?
        let didOpen = sender.getInputStream(&inputStream, outputStream: &outputStream)
        if didOpen {
            let service = ServerService(inputStream: inputStream!, outpuStream: outputStream!)
            services.append(service)
            
            inputStream?.schedule(in: RunLoop.main, forMode: .defaultRunLoopMode)
            outputStream?.schedule(in: RunLoop.main, forMode: .defaultRunLoopMode)
            inputStream?.open()
            outputStream?.open()
            
            let readContent = {
                let content = try? JSONSerialization.jsonObject(with: inputStream!, options: [])
                print(content)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                let content = try! JSONSerialization.jsonObject(with: inputStream!, options: [])
                print(content)
            })
            readContent()
        }
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("failed to resove service \(sender): \(errorDict)")
    }
}



extension NFXNetService {
    func loadAllRequests(address: String, port: Int) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        if let url = URL(string: "http://\(address):\(port)/\(NFXServer.Options.allRequests)") {
            let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Failed \(error)")
                } else {
                    guard let data = data else { return }
                    guard let response = response as? HTTPURLResponse else {  return }
                    guard response.statusCode >= 200 && response.statusCode < 300 else { return }
                    
                    
                    NFX.sharedInstance().addJSONModels(data)
                }
            })
            
            dataTask.resume()
        }
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
