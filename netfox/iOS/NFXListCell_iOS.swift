//
//  NFXListCell.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

#if os(iOS)
    
import UIKit

#if swift(>=4.2)
typealias UITableViewCellStyle = UITableViewCell.CellStyle
#endif

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
        backgroundColor = UIColor.clear
        selectionStyle = .none
        

        self.statusView = UIView(frame: CGRect.zero)
        contentView.addSubview(self.statusView)
        
        self.requestTimeLabel = UILabel(frame: CGRect.zero)
        self.requestTimeLabel.textAlignment = .center
        self.requestTimeLabel.textColor = UIColor.white
        self.requestTimeLabel.font = UIFont.NFXFontBold(size: 13)
        contentView.addSubview(self.requestTimeLabel)
        
        self.timeIntervalLabel = UILabel(frame: CGRect.zero)
        self.timeIntervalLabel.textAlignment = .center
        self.timeIntervalLabel.font = UIFont.NFXFont(size: 12)
        contentView.addSubview(self.timeIntervalLabel)
        
        self.URLLabel = UILabel(frame: CGRect.zero)
        self.URLLabel.textColor = UIColor.NFXBlackColor()
        self.URLLabel.font = UIFont.NFXFont(size: 12)
        self.URLLabel.numberOfLines = 2
        contentView.addSubview(self.URLLabel)

        self.methodLabel = UILabel(frame: CGRect.zero)
        self.methodLabel.textAlignment = .left
        self.methodLabel.textColor = UIColor.NFXGray44Color()
        self.methodLabel.font = UIFont.NFXFont(size: 12)
        contentView.addSubview(self.methodLabel)
        
        self.typeLabel = UILabel(frame: CGRect.zero)
        self.typeLabel.textColor = UIColor.NFXGray44Color()
        self.typeLabel.font = UIFont.NFXFont(size: 12)
        contentView.addSubview(self.typeLabel)
        
        self.circleView = UIView(frame: CGRect.zero)
        self.circleView.backgroundColor = UIColor.NFXGray44Color()
        self.circleView.layer.cornerRadius = 4
        self.circleView.alpha = 0.2
        contentView.addSubview(self.circleView)
        
        self.leftSeparator = UIView(frame: CGRect.zero)
        self.leftSeparator.backgroundColor = UIColor.white
        contentView.addSubview(self.leftSeparator)
        
        self.rightSeparator = UIView(frame: CGRect.zero)
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
        
        self.statusView.frame = CGRect(x: 0, y: 0, width: 50, height: frame.height - 1)

        self.requestTimeLabel.frame = CGRect(x: 0, y: 13, width: statusView.frame.width, height: 14)
        
        self.timeIntervalLabel.frame = CGRect(x: 0, y: requestTimeLabel.frame.maxY + 5, width: statusView.frame.width, height: 14)
        
        self.URLLabel.frame = CGRect(x: statusView.frame.maxX + padding, y: 0, width: frame.width - URLLabel.frame.minX - 25 - padding, height: 40)
        self.URLLabel.autoresizingMask = .flexibleWidth
        
        self.methodLabel.frame = CGRect(x: statusView.frame.maxX + padding, y: URLLabel.frame.maxY - 2, width: 40, height: frame.height - URLLabel.frame.maxY - 2)

        self.typeLabel.frame = CGRect(x: methodLabel.frame.maxX + padding, y: URLLabel.frame.maxY - 2, width: 180, height: frame.height - URLLabel.frame.maxY - 2)

        self.circleView.frame = CGRect(x: self.URLLabel.frame.maxX + 5, y: 17, width: 8, height: 8)
        
        self.leftSeparator.frame = CGRect(x: 0, y: frame.height - 1, width: self.statusView.frame.width, height: 1)
        self.rightSeparator.frame = CGRect(x: self.leftSeparator.frame.maxX, y: frame.height - 1, width: frame.width - self.leftSeparator.frame.maxX, height: 1)
        
    }
    
    func isNew()
    {
        self.circleView.isHidden = false
    }
    
    func isOld()
    {
        self.circleView.isHidden = true
    }
    
    func configForObject(_ obj: NFXHTTPModel)
    {
        setURL(obj.requestURL ?? "-")
        setStatus(obj.responseStatus ?? 999)
        setTimeInterval(obj.timeInterval ?? 999)
        setRequestTime(obj.requestTime ?? "-")
        setType(obj.responseType ?? "-")
        setMethod(obj.requestMethod ?? "-")
        isNewBasedOnDate(obj.responseDate as Date? ?? Date())
    }
    
    func setURL(_ url: String)
    {
        self.URLLabel.text = url
    }
    
    func setStatus(_ status: Int)
    {
        if status == 999 {
            self.statusView.backgroundColor = UIColor.NFXGray44Color() //gray
            self.timeIntervalLabel.textColor = UIColor.white

        } else if status < 400 {
            self.statusView.backgroundColor = UIColor.NFXGreenColor() //green
            self.timeIntervalLabel.textColor = UIColor.NFXDarkGreenColor()

        } else {
            self.statusView.backgroundColor = UIColor.NFXRedColor() //red
            self.timeIntervalLabel.textColor = UIColor.NFXDarkRedColor()

        }
    }
    
    func setRequestTime(_ requestTime: String)
    {
        self.requestTimeLabel.text = requestTime
    }
    
    func setTimeInterval(_ timeInterval: Float)
    {
        if timeInterval == 999 {
            self.timeIntervalLabel.text = "-"
        } else {
            self.timeIntervalLabel.text = NSString(format: "%.2f", timeInterval) as String
        }
    }
    
    func setType(_ type: String)
    {
        self.typeLabel.text = type
    }
    
    func setMethod(_ method: String)
    {
        self.methodLabel.text = method
    }
    
    func isNewBasedOnDate(_ responseDate: Date)
    {
        if responseDate.isGreaterThanDate(NFX.sharedInstance().getLastVisitDate()) {
            self.isNew()
        } else {
            self.isOld()
        }
    }
}

#endif
