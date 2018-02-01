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
    
    init (inputStream: InputStream, outputStream: OutputStream) {
        self.inputStream = inputStream
        self.outputStream = outputStream
    }
    
    deinit {
        inputStream.close()
        outputStream.close()
    }
    
    func scheduleOnMainRunLoop() {
        inputStream.schedule(in: RunLoop.main, forMode: .commonModes)
        outputStream.schedule(in: RunLoop.main, forMode: .commonModes)
        inputStream.open()
        outputStream.open()
    }
    
    func writeModel(_ model: NFXHTTPModel) {
        let models =  [ model.toJSON() ]
        let jsonData = try! JSONSerialization.data(withJSONObject: models, options: [])
        writeData(jsonData)
    }
    
    func writeAllModels() {
        let models = NFXHTTPModelManager.sharedInstance.getModels().map({ $0.toJSON() })
        let jsonData = try! JSONSerialization.data(withJSONObject: models, options: [])
        writeData(jsonData)
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
            if bytesWritten < 0 {
                print("An error occured while writing data")
                return
            }
            
            bytesWritten += writeCount
        }
    }
    
    func prepareForReadingStream() {
        inputStream.delegate = self
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
            break
        case .openCompleted, .hasSpaceAvailable:
            break
        default:
            break
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
