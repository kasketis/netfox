//
//  NFXListCell.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation

import UIKit

class StockCell: UITableViewCell
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

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        

        self.statusView = UIView(frame: CGRectZero)
        contentView.addSubview(statusView)
        
        self.requestTimeLabel = UILabel(frame: CGRectZero)
        self.requestTimeLabel.textAlignment = .Center
        self.requestTimeLabel.textColor = UIColor.whiteColor()
        self.requestTimeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(12))
        contentView.addSubview(self.requestTimeLabel)
        
        self.timeIntervalLabel = UILabel(frame: CGRectZero)
        self.timeIntervalLabel.textAlignment = .Center
        self.timeIntervalLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(11))
        contentView.addSubview(self.timeIntervalLabel)
        
        self.URLLabel = UILabel(frame: CGRectZero)
        self.URLLabel.textColor = UIColor.init(netHex: 0x231f20)
        self.URLLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(11))
        self.URLLabel.numberOfLines = 2
        contentView.addSubview(self.URLLabel)

        self.methodLabel = UILabel(frame: CGRectZero)
        self.methodLabel.textAlignment = .Left
        self.methodLabel.textColor = UIColor.init(netHex: 0x707070)
        self.methodLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(11))
        contentView.addSubview(self.methodLabel)
        
        self.typeLabel = UILabel(frame: CGRectZero)
        self.typeLabel.textColor = UIColor.init(netHex: 0x707070)
        self.typeLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(11))
        contentView.addSubview(self.typeLabel)
        
        self.leftSeparator = UIView(frame: CGRectZero)
        self.leftSeparator.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(self.leftSeparator)
        
        self.rightSeparator = UIView(frame: CGRectZero)
        self.rightSeparator.backgroundColor = UIColor.init(netHex: 0x9b9b9b)
        contentView.addSubview(self.rightSeparator)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.statusView.frame = CGRectMake(0, 0, 50, frame.height - 1)

        self.requestTimeLabel.frame = CGRectMake(0, 15, CGRectGetWidth(statusView.frame), 14)
        
        self.timeIntervalLabel.frame = CGRectMake(0, CGRectGetMaxY(requestTimeLabel.frame) + 5, CGRectGetWidth(statusView.frame), 14)
        
        self.URLLabel.frame = CGRectMake(CGRectGetMaxX(statusView.frame) + padding, 0, frame.width - CGRectGetMinX(URLLabel.frame) - padding, 40)
        self.URLLabel.autoresizingMask = .FlexibleWidth
        
        self.methodLabel.frame = CGRectMake(CGRectGetMaxX(statusView.frame) + padding, CGRectGetMaxY(URLLabel.frame), 40, frame.height - CGRectGetMaxY(URLLabel.frame) - padding)

        self.typeLabel.frame = CGRectMake(CGRectGetMaxX(methodLabel.frame) + padding, CGRectGetMaxY(URLLabel.frame), 180, frame.height - CGRectGetMaxY(URLLabel.frame) - padding)

        self.leftSeparator.frame = CGRectMake(0, frame.height - 1, CGRectGetWidth(self.statusView.frame), 1)
        self.rightSeparator.frame = CGRectMake(CGRectGetMaxX(self.leftSeparator.frame), frame.height - 1, frame.width - CGRectGetMaxX(self.leftSeparator.frame), 1)

    }
    
    func configForObject(obj : NFXHTTPModel)
    {
        setURL(obj.requestURL ?? "-")
        setStatus(obj.responseStatus ?? 999)
        setTimeInterval(obj.timeInterval ?? "-")
        setRequestTime(obj.requestTime ?? "-")
        setType(obj.responseType ?? "-")
        setMethod(obj.requestMethod ?? "-")
    }
    
    func setURL(url : String)
    {
        self.URLLabel.text = url
    }
    
    func setStatus(status: Int)
    {
        if status < 400 {
            self.statusView.backgroundColor = UIColor.init(netHex: 0x38bb93) //green
            self.timeIntervalLabel.textColor = UIColor.init(netHex: 0x2d7c6e)

        } else {
            self.statusView.backgroundColor = UIColor.init(netHex: 0xd34a33) //red
            self.timeIntervalLabel.textColor = UIColor.init(netHex: 0x643026)

        }
    }
    
    func setRequestTime(requestTime : String)
    {
        self.requestTimeLabel.text = requestTime
    }
    
    func setTimeInterval(timeInterval : String)
    {
        self.timeIntervalLabel.text = timeInterval
    }
    
    func setType(type : String)
    {
        self.typeLabel.text = type
    }
    
    func setMethod(method : String)
    {
        self.methodLabel.text = method
    }
}