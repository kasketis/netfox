//
//  NFXStatisticsController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class NFXStatisticsController: NFXGenericController {
    var totalModels: Int = 0

    var successfulRequests: Int = 0
    var failedRequests: Int = 0
    
    var totalRequestSize: Int = 0
    var totalResponseSize: Int = 0
    
    var totalResponseTime: Float = 0
    
    var fastestResponseTime: Float = 999
    var slowestResponseTime: Float = 0
    
    private lazy var dataSubscription = Subscription<[NFXHTTPModel]> { [weak self] in self?.reloadData(with: $0) }
    
    deinit {
        dataSubscription.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NFXHTTPModelManager.shared.publisher.subscribe(dataSubscription)
        reloadData(with: NFXHTTPModelManager.shared.filteredModels)
    }
    
    
    func getReportString() -> NSAttributedString {
        var tempString: String
        tempString = String()
        
        tempString += "[Total requests] \n\(totalModels)\n\n"
        
        tempString += "[Successful requests] \n\(successfulRequests)\n\n"
        tempString += "[Failed requests] \n\(failedRequests)\n\n"
        
        tempString += "[Total request size] \n\(Float(totalRequestSize/1024)) KB\n\n"
        if totalModels == 0 {
            tempString += "[Avg request size] \n0.0 KB\n\n"
        } else {
            tempString += "[Avg request size] \n\(Float((totalRequestSize/totalModels)/1024)) KB\n\n"
        }
        
        tempString += "[Total response size] \n\(Float(totalResponseSize/1024)) KB\n\n"
        if totalModels == 0 {
            tempString += "[Avg response size] \n0.0 KB\n\n"
        } else {
            tempString += "[Avg response size] \n\(Float((totalResponseSize/totalModels)/1024)) KB\n\n"
        }

        if self.totalModels == 0 {
            tempString += "[Avg response time] \n0.0s\n\n"
            tempString += "[Fastest response time] \n0.0s\n\n"
        } else {
            tempString += "[Avg response time] \n\(Float(totalResponseTime/Float(totalModels)))s\n\n"
            if fastestResponseTime == 999 {
                tempString += "[Fastest response time] \n0.0s\n\n"
            } else {
                tempString += "[Fastest response time] \n\(fastestResponseTime)s\n\n"
            }
        }
        tempString += "[Slowest response time] \n\(slowestResponseTime)s\n\n"

        return formatNFXString(tempString)
    }
    
    private func reloadData(with models: [NFXHTTPModel]) {
        clearStatistics()
        generateStatistics(models)
        reloadData()
    }
    
    private func generateStatistics(_ models: [NFXHTTPModel]) {
        totalModels = models.count
        
        for model in models {
            
            if model.isSuccessful() {
                successfulRequests += 1
            } else  {
                failedRequests += 1
            }
            
            if (model.requestBodyLength != nil) {
                totalRequestSize += model.requestBodyLength!
            }
            
            if (model.responseBodyLength != nil) {
                totalResponseSize += model.responseBodyLength!
            }
            
            if (model.timeInterval != nil) {
                totalResponseTime += model.timeInterval!
                
                if model.timeInterval < fastestResponseTime {
                    fastestResponseTime = model.timeInterval!
                }
                
                if model.timeInterval > slowestResponseTime {
                    slowestResponseTime = model.timeInterval!
                }
            }
        }
    }
    
    private func clearStatistics() {
        totalModels = 0
        successfulRequests = 0
        failedRequests = 0
        totalRequestSize = 0
        totalResponseSize = 0
        totalResponseTime = 0
        fastestResponseTime = 999
        slowestResponseTime = 0
    }
    
}
