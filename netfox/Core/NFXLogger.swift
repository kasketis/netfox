//
//  NFXLogger.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation
@objc
final class NFXLogger: NSObject {
    static let shared = NFXLogger()
    
    var debugLogs: Bool = true
    
    @objc public func log(_ message: String) {
        guard debugLogs else { return }
        print(message)
    }
}
