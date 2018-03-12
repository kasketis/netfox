//
//  NFXClientConnection.swift
//  netfox
//
//  Created by Alexandru Tudose on 01/02/2018.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

class NFXClientConnection: NSObject {
    let inputStream: InputStream
    let outputStream: OutputStream
    
    private var thread: Thread!
    private var runLoop: CFRunLoop?
    
    var _onClose: (() -> Void)?
    
    init (inputStream: InputStream, outputStream: OutputStream) {
        self.inputStream = inputStream
        self.outputStream = outputStream
    }
    
    deinit {
        inputStream.close()
        outputStream.close()
    }
    
    func scheduleOnBackgroundRunLoop() {
        let threadName = String(describing: self).components(separatedBy: .punctuationCharacters)[1]
        thread = Thread(target: self, selector: #selector(startRunLoop), object: nil)
        thread.name = "\(threadName)-\(UUID().uuidString)"
        thread.start()
    }
    
    @objc func startRunLoop() {
        scheduleOnRunLoop()
        self.runLoop = CFRunLoopGetCurrent()
        CFRunLoopRun()
    }
    
    @objc func stopRunLoop() {
        self.thread?.cancel()
        self.thread = nil
        if let runLoop = runLoop {
            CFRunLoopStop(runLoop)
        }
    }
    
    @objc func scheduleOnRunLoop() {
        inputStream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        outputStream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        inputStream.open()
        outputStream.open()
    }
    
    var onClose: (() -> Void)? {
        get { return _onClose }
        set { _onClose = {[unowned self] in
                self.inputStream.delegate = nil
                self.stopRunLoop()
                self.inputStream.close()
                self.outputStream.close()
                DispatchQueue.main.async {
                    newValue?()
                }
            }
        }
    }
    
    static let serialQueue = DispatchQueue(label: "NFXClientConnection")
    @objc func writeModel(_ model: NFXHTTPModel) {
        NFXClientConnection.serialQueue.async {
            let models =  [ model.toJSON() ]
            let jsonData = try! JSONSerialization.data(withJSONObject: models, options: [])
            self.writeData(jsonData)
        }
    }
    
    @objc func writeAllModels() {
        NFXClientConnection.serialQueue.async {
            let models = NFXHTTPModelManager.sharedInstance.getModels()
            models.reversed().chunked(by: 20).forEach({ items in
                print(items.count)
                let models = items.map({ $0.toJSON() })
                let jsonData = try! JSONSerialization.data(withJSONObject: models, options: [])
                self.writeData(jsonData)
            })
        }
    }
    
    func writeData(_ data: Data) {
        // write size of payload
        let messageSize = Int32(data.count)
        outputStream.write(toByteArrary(value: messageSize), maxLength: MemoryLayout.size(ofValue: messageSize))
        
        // write payload
        let bytes = [UInt8](data)
        var bytesWritten = 0
        while bytes.count > bytesWritten {
            let count = bytes.count - bytesWritten
            let writeCount = outputStream.write([UInt8](bytes[bytesWritten...bytes.count - 1]), maxLength: count)
            if writeCount == -1 {
                onClose?()
                print(outputStream.streamError ?? "")
                print("Netfox connection - An error occured while writing data")
                return
            }
            
            bytesWritten += writeCount
        }
    }
    
    func prepareForReadingStream() {
        inputStream.delegate = self
    }
    
    func prepareForWritingStream() {
        outputStream.delegate = self
    }
    
    var bufferData: Data = Data()
    var toReadCount: Int = 0
    
    func readData() {
        if toReadCount == 0 {
            var sizeBuffer: [UInt8] = [0,0,0,0]
            inputStream.read(&sizeBuffer, maxLength: sizeBuffer.count)
            let data = NSData(bytes: sizeBuffer, length: sizeBuffer.count)
            toReadCount = Int(data.uint32.littleEndian)
            bufferData = Data()
        }
        
        let bufferSize = min(toReadCount, 2048)
        var buffer = Array<UInt8>(repeating: 0, count: bufferSize)
        let readCount = inputStream.read(&buffer, maxLength: bufferSize)
        bufferData.append(buffer, count: readCount)
        toReadCount -= readCount
        if toReadCount == 0 {
            NFX.sharedInstance().addJSONModels(bufferData)
            bufferData = Data()
        }
    }
}


extension NFXClientConnection: StreamDelegate {
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        guard let _ = aStream as? InputStream else {
            return
        }
        
        switch eventCode {
        case .hasBytesAvailable:
            readData()
        case .errorOccurred, .endEncountered:
            print(eventCode)
            onClose?()
        case .openCompleted, .hasSpaceAvailable:
            break
        default:
            break
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
            
            models.reversed().forEach({ NFXHTTPModelManager.sharedInstance.add($0) })
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "NFXReloadData"), object: nil)
            }
        }
    }
}


func toByteArrary<T>(value: T)  -> [UInt8] where T: FixedWidthInteger{
    var bigEndian = value.littleEndian
    let count = MemoryLayout<T>.size
    let bytePtr = withUnsafePointer(to: &bigEndian) {
        $0.withMemoryRebound(to: UInt8.self, capacity: count) {
            UnsafeBufferPointer(start: $0, count: count)
        }
    }
    
    return Array(bytePtr)
}

extension NSData {
    var uint32: UInt32 {
        get {
            var number: UInt32 = 0
            self.getBytes(&number, length: MemoryLayout<UInt32>.size)
            return number
        }
    }
}


extension Array {
    func chunked(by chunkSize:Int) -> [[Element]] {
        let groups = stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<[$0 + chunkSize, self.count].min()!])
        }
        return groups
    }
}
