//
//  NFXListCell.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

#if os(iOS)
    
import UIKit

class NFXListCell: UITableViewCell {
    
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

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        selectionStyle = .none
        

        statusView = UIView(frame: CGRect.zero)
        contentView.addSubview(statusView)
        
        requestTimeLabel = UILabel(frame: CGRect.zero)
        requestTimeLabel.textAlignment = .center
        requestTimeLabel.textColor = UIColor.white
        requestTimeLabel.font = UIFont.NFXFontBold(size: 13)
        contentView.addSubview(requestTimeLabel)
        
        timeIntervalLabel = UILabel(frame: CGRect.zero)
        timeIntervalLabel.textAlignment = .center
        timeIntervalLabel.font = UIFont.NFXFont(size: 12)
        contentView.addSubview(timeIntervalLabel)
        
        URLLabel = UILabel(frame: CGRect.zero)
        URLLabel.textColor = UIColor.NFXBlackColor()
        URLLabel.font = UIFont.NFXFont(size: 12)
        URLLabel.numberOfLines = 2
        contentView.addSubview(URLLabel)

        methodLabel = UILabel(frame: CGRect.zero)
        methodLabel.textAlignment = .left
        methodLabel.textColor = UIColor.NFXGray44Color()
        methodLabel.font = UIFont.NFXFont(size: 12)
        contentView.addSubview(methodLabel)
        
        typeLabel = UILabel(frame: CGRect.zero)
        typeLabel.textColor = UIColor.NFXGray44Color()
        typeLabel.font = UIFont.NFXFont(size: 12)
        contentView.addSubview(typeLabel)
        
        circleView = UIView(frame: CGRect.zero)
        circleView.backgroundColor = UIColor.NFXGray44Color()
        circleView.layer.cornerRadius = 4
        circleView.alpha = 0.2
        contentView.addSubview(circleView)
        
        leftSeparator = UIView(frame: CGRect.zero)
        leftSeparator.backgroundColor = UIColor.white
        contentView.addSubview(leftSeparator)
        
        rightSeparator = UIView(frame: CGRect.zero)
        rightSeparator.backgroundColor = UIColor.NFXLightGrayColor()
        contentView.addSubview(rightSeparator)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        statusView.frame = CGRect(x: 0, y: 0, width: 50, height: frame.height - 1)

        requestTimeLabel.frame = CGRect(x: 0, y: 13, width: statusView.frame.width, height: 14)
        
        timeIntervalLabel.frame = CGRect(x: 0, y: requestTimeLabel.frame.maxY + 5, width: statusView.frame.width, height: 14)
        
        URLLabel.frame = CGRect(x: statusView.frame.maxX + padding, y: 0, width: frame.width - URLLabel.frame.minX - 25 - padding, height: 40)
        URLLabel.autoresizingMask = .flexibleWidth
        
        methodLabel.frame = CGRect(x: statusView.frame.maxX + padding, y: URLLabel.frame.maxY - 2, width: 40, height: frame.height - URLLabel.frame.maxY - 2)

        typeLabel.frame = CGRect(x: methodLabel.frame.maxX + padding, y: URLLabel.frame.maxY - 2, width: 180, height: frame.height - URLLabel.frame.maxY - 2)

        circleView.frame = CGRect(x: URLLabel.frame.maxX + 5, y: 17, width: 8, height: 8)
        
        leftSeparator.frame = CGRect(x: 0, y: frame.height - 1, width: statusView.frame.width, height: 1)
        rightSeparator.frame = CGRect(x: leftSeparator.frame.maxX, y: frame.height - 1, width: frame.width - leftSeparator.frame.maxX, height: 1)
    }
    
    func isNew() {
        circleView.isHidden = false
    }
    
    func isOld() {
        circleView.isHidden = true
    }
    
    func configForObject(_ obj: NFXHTTPModel) {
        setURL(obj.requestURL ?? "-")
        setStatus(obj.responseStatus ?? 999)
        setTimeInterval(obj.timeInterval ?? 999)
        setRequestTime(obj.requestTime ?? "-")
        setType(obj.responseType ?? "-")
        setMethod(obj.requestMethod ?? "-")
        isNewBasedOnDate(obj.responseDate as Date? ?? Date())
    }
    
    func setURL(_ url: String) {
        URLLabel.text = url
    }
    
    func setStatus(_ status: Int) {
        if status == 999 {
            statusView.backgroundColor = UIColor.NFXGray44Color() //gray
            timeIntervalLabel.textColor = UIColor.white

        } else if status < 400 {
            statusView.backgroundColor = UIColor.NFXGreenColor() //green
            timeIntervalLabel.textColor = UIColor.NFXDarkGreenColor()

        } else {
            statusView.backgroundColor = UIColor.NFXRedColor() //red
            timeIntervalLabel.textColor = UIColor.NFXDarkRedColor()
        }
    }
    
    func setRequestTime(_ requestTime: String) {
        requestTimeLabel.text = requestTime
    }
    
    func setTimeInterval(_ timeInterval: Float) {
        if timeInterval == 999 {
            timeIntervalLabel.text = "-"
        } else {
            timeIntervalLabel.text = NSString(format: "%.2f", timeInterval) as String
        }
    }
    
    func setType(_ type: String) {
        typeLabel.text = type
    }
    
    func setMethod(_ method: String) {
        methodLabel.text = method
    }
    
    func isNewBasedOnDate(_ responseDate: Date) {
        if responseDate.isGreaterThanDate(NFX.sharedInstance().getLastVisitDate()) {
            isNew()
        } else {
            isOld()
        }
    }
}

#endif
