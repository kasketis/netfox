//
//  NFXStatisticsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//


import Foundation
import UIKit

class NFXStatisticsController: NFXGenericController
{
    var scrollView: UIScrollView = UIScrollView()
    var textLabel: UILabel = UILabel()

    var totalModels: Int = 0

    var successfulRequests: Int = 0
    var failedRequests: Int = 0
    
    var totalRequestSize: Int = 0
    var totalResponseSize: Int = 0
    
    var totalResponseTime: Float = 0
    
    var fastestResponseTime: Float = 999
    var slowestResponseTime: Float = 0

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Statistics"
        
        generateStatics()
        
        self.scrollView = UIScrollView()
        self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        self.scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.scrollView.autoresizesSubviews = true
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.scrollView)

        self.textLabel = UILabel()
        self.textLabel.frame = CGRectMake(20, 20, CGRectGetWidth(scrollView.frame) - 40, CGRectGetHeight(scrollView.frame) - 20);
        self.textLabel.font = UIFont.NFXFont(13)
        self.textLabel.textColor = UIColor.NFXGray44Color()
        self.textLabel.numberOfLines = 0
        self.textLabel.attributedText = getReportString()
        self.textLabel.sizeToFit()
        self.scrollView.addSubview(self.textLabel)
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame), CGRectGetMaxY(self.textLabel.frame))
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "reloadData",
            name: "NFXReloadData",
            object: nil)
        
    }
    
    func getReportString() -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
        tempString += "[Total requests] \n\(self.totalModels)\n\n"
        
        tempString += "[Successful requests] \n\(self.successfulRequests)\n\n"
        tempString += "[Failed requests] \n\(self.failedRequests)\n\n"
        
        tempString += "[Total request size] \n\(Float(self.totalRequestSize/1024)) KB\n\n"
        if self.totalModels == 0 {
            tempString += "[Avg request size] \n0.0 KB\n\n"
        } else {
            tempString += "[Avg request size] \n\(Float((self.totalRequestSize/self.totalModels)/1024)) KB\n\n"
        }
        
        tempString += "[Total response size] \n\(Float(self.totalResponseSize/1024)) KB\n\n"
        if self.totalModels == 0 {
            tempString += "[Avg response size] \n0.0 KB\n\n"
        } else {
            tempString += "[Avg response size] \n\(Float((self.totalResponseSize/self.totalModels)/1024)) KB\n\n"
        }

        if self.totalModels == 0 {
            tempString += "[Avg response time] \n0.0s\n\n"
            tempString += "[Fastest response time] \n0.0s\n\n"
        } else {
            tempString += "[Avg response time] \n\(Float(self.totalResponseTime/Float(self.totalModels)))s\n\n"
            if self.fastestResponseTime == 999 {
                tempString += "[Fastest response time] \n0.0s\n\n"
            } else {
                tempString += "[Fastest response time] \n\(self.fastestResponseTime)s\n\n"
            }
        }
        tempString += "[Slowest response time] \n\(self.slowestResponseTime)s\n\n"

        return formatNFXString(tempString)
    }
    
    func generateStatics()
    {
        let models = NFXHTTPModelManager.sharedInstance.getModels()
        totalModels = models.count
        
        for model in models {
            
            if model.isSuccessful() {
                successfulRequests++
            } else  {
                failedRequests++
            }
            
            if (model.requestBodyLength != nil) {
                totalRequestSize += model.requestBodyLength!
            }
            
            if (model.responseBodyLength != nil) {
                totalResponseSize += model.responseBodyLength!
            }
            
            if (model.timeInterval != nil) {
                totalResponseTime += model.timeInterval!
                
                if model.timeInterval < self.fastestResponseTime {
                    self.fastestResponseTime = model.timeInterval!
                }
                
                if model.timeInterval > self.slowestResponseTime {
                    self.slowestResponseTime = model.timeInterval!
                }
            }
            
        }
    }
    
    func clearStatistics()
    {
        self.totalModels = 0
        self.successfulRequests = 0
        self.failedRequests = 0
        self.totalRequestSize = 0
        self.totalResponseSize = 0
        self.totalResponseTime = 0
        self.fastestResponseTime = 999
        self.slowestResponseTime = 0
    }
    
    override func reloadData()
    {
        clearStatistics()
        generateStatics()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.textLabel.attributedText = self.getReportString()
        }
    }
}