//
//  NFXListCell.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation

import UIKit

class NFXListCell: UITableViewCell
{
    
    let padding: CGFloat = 5
    var URLLabel: UILabel!
    var statusView: UIView!
    var requestTimeLabel: UILabel!
    var timeIntervalLabel: UILabel!
    var typeLabel: UILabel!
    var methodLabel: UILabel!
    var leftSeparator: UIView!
    var rightSeparator: UIView!
    var circleView: UIView!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        

        self.statusView = UIView(frame: CGRectZero)
        contentView.addSubview(self.statusView)
        
        self.requestTimeLabel = UILabel(frame: CGRectZero)
        self.requestTimeLabel.textAlignment = .Center
        self.requestTimeLabel.textColor = UIColor.whiteColor()
        self.requestTimeLabel.font = UIFont.NFXFontBold(13)
        contentView.addSubview(self.requestTimeLabel)
        
        self.timeIntervalLabel = UILabel(frame: CGRectZero)
        self.timeIntervalLabel.textAlignment = .Center
        self.timeIntervalLabel.font = UIFont.NFXFont(12)
        contentView.addSubview(self.timeIntervalLabel)
        
        self.URLLabel = UILabel(frame: CGRectZero)
        self.URLLabel.textColor = UIColor.NFXBlackColor()
        self.URLLabel.font = UIFont.NFXFont(12)
        self.URLLabel.numberOfLines = 2
        contentView.addSubview(self.URLLabel)

        self.methodLabel = UILabel(frame: CGRectZero)
        self.methodLabel.textAlignment = .Left
        self.methodLabel.textColor = UIColor.NFXGray44Color()
        self.methodLabel.font = UIFont.NFXFont(12)
        contentView.addSubview(self.methodLabel)
        
        self.typeLabel = UILabel(frame: CGRectZero)
        self.typeLabel.textColor = UIColor.NFXGray44Color()
        self.typeLabel.font = UIFont.NFXFont(12)
        contentView.addSubview(self.typeLabel)
        
        self.circleView = UIView(frame: CGRectZero)
        self.circleView.backgroundColor = UIColor.NFXGray44Color()
        self.circleView.layer.cornerRadius = 4
        self.circleView.alpha = 0.2
        contentView.addSubview(self.circleView)
        
        self.leftSeparator = UIView(frame: CGRectZero)
        self.leftSeparator.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(self.leftSeparator)
        
        self.rightSeparator = UIView(frame: CGRectZero)
        self.rightSeparator.backgroundColor = UIColor.NFXLightGrayColor()
        contentView.addSubview(self.rightSeparator)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.statusView.frame = CGRectMake(0, 0, 50, frame.height - 1)

        self.requestTimeLabel.frame = CGRectMake(0, 13, CGRectGetWidth(statusView.frame), 14)
        
        self.timeIntervalLabel.frame = CGRectMake(0, CGRectGetMaxY(requestTimeLabel.frame) + 5, CGRectGetWidth(statusView.frame), 14)
        
        self.URLLabel.frame = CGRectMake(CGRectGetMaxX(statusView.frame) + padding, 0, frame.width - CGRectGetMinX(URLLabel.frame) - 25 - padding, 40)
        self.URLLabel.autoresizingMask = .FlexibleWidth
        
        self.methodLabel.frame = CGRectMake(CGRectGetMaxX(statusView.frame) + padding, CGRectGetMaxY(URLLabel.frame) - 2, 40, frame.height - CGRectGetMaxY(URLLabel.frame) - 2)

        self.typeLabel.frame = CGRectMake(CGRectGetMaxX(methodLabel.frame) + padding, CGRectGetMaxY(URLLabel.frame) - 2, 180, frame.height - CGRectGetMaxY(URLLabel.frame) - 2)

        self.circleView.frame = CGRectMake(CGRectGetMaxX(self.URLLabel.frame) + 5, 17, 8, 8)
        
        self.leftSeparator.frame = CGRectMake(0, frame.height - 1, CGRectGetWidth(self.statusView.frame), 1)
        self.rightSeparator.frame = CGRectMake(CGRectGetMaxX(self.leftSeparator.frame), frame.height - 1, frame.width - CGRectGetMaxX(self.leftSeparator.frame), 1)
        
    }
    
    func isNew()
    {
        self.circleView.hidden = false
    }
    
    func isOld()
    {
        self.circleView.hidden = true
    }
    
    func configForObject(obj: NFXHTTPModel)
    {
        setURL(obj.requestURL ?? "-")
        setStatus(obj.responseStatus ?? 999)
        setTimeInterval(obj.timeInterval ?? 999)
        setRequestTime(obj.requestTime ?? "-")
        setType(obj.responseType ?? "-")
        setMethod(obj.requestMethod ?? "-")
        isNewBasedOnDate(obj.responseDate ?? NSDate())
    }
    
    func setURL(url: String)
    {
        self.URLLabel.text = url
    }
    
    func setStatus(status: Int)
    {
        if status == 999 {
            self.statusView.backgroundColor = UIColor.NFXGray44Color() //gray
            self.timeIntervalLabel.textColor = UIColor.whiteColor()

        } else if status < 400 {
            self.statusView.backgroundColor = UIColor.NFXGreenColor() //green
            self.timeIntervalLabel.textColor = UIColor.NFXDarkGreenColor()

        } else {
            self.statusView.backgroundColor = UIColor.NFXRedColor() //red
            self.timeIntervalLabel.textColor = UIColor.NFXDarkRedColor()

        }
    }
    
    func setRequestTime(requestTime: String)
    {
        self.requestTimeLabel.text = requestTime
    }
    
    func setTimeInterval(timeInterval: Float)
    {
        if timeInterval == 999 {
            self.timeIntervalLabel.text = "-"
        } else {
            self.timeIntervalLabel.text = NSString(format: "%.2f", timeInterval) as String
        }
    }
    
    func setType(type: String)
    {
        self.typeLabel.text = type
    }
    
    func setMethod(method: String)
    {
        self.methodLabel.text = method
    }
    
    func isNewBasedOnDate(responseDate: NSDate)
    {
        if responseDate.isGreaterThanDate(NFX.sharedInstance().getLastVisitDate()) {
            self.isNew()
        } else {
            self.isOld()
        }
    }
}