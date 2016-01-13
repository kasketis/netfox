//
//  NFXListCell_OSX.swift
//  NetfoxForMac
//
//  Created by Tom Baranes on 12/01/16.
//  Copyright © 2016 Netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa

class NFXListCell_OSX: NSTableCellView {

    let padding: CGFloat = 5
    var URLLabel: NSTextField!
    var statusView: NSView!
    var requestTimeLabel: NSTextField!
    var timeIntervalLabel: NSTextField!
    var typeLabel: NSTextField!
    var methodLabel: NSTextField!
    var leftSeparator: NSView!
    var rightSeparator: NSView!
    var circleView: NSView!
    
    // MARK: Life cycle
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layer?.backgroundColor = NFXColor.clearColor().CGColor
        
        self.statusView = NSView(frame: CGRectZero)
        self.addSubview(self.statusView)

        self.requestTimeLabel = NSTextField(frame: CGRectZero)
        self.requestTimeLabel.alignment = .Center
        self.requestTimeLabel.textColor = NSColor.whiteColor()
        self.requestTimeLabel.font = NSFont.NFXFontBold(13)
        self.addSubview(self.requestTimeLabel)

        self.timeIntervalLabel = NSTextField(frame: CGRectZero)
        self.timeIntervalLabel.alignment = .Center
        self.timeIntervalLabel.font = NSFont.NFXFont(12)
        self.addSubview(self.timeIntervalLabel)

        self.URLLabel = NSTextField(frame: CGRectZero)
        self.URLLabel.textColor = NSColor.NFXBlackColor()
        self.URLLabel.font = NSFont.NFXFont(12)
//        self.URLLabel.m
        self.addSubview(self.URLLabel)

        self.methodLabel = NSTextField(frame: CGRectZero)
        self.methodLabel.alignment = .Left
        self.methodLabel.textColor = NSColor.NFXGray44Color()
        self.methodLabel.font = NSFont.NFXFont(12)
        self.addSubview(self.methodLabel)

        self.typeLabel = NSTextField(frame: CGRectZero)
        self.typeLabel.textColor = NSColor.NFXGray44Color()
        self.typeLabel.font = NSFont.NFXFont(12)
        self.addSubview(self.typeLabel)

        self.circleView = NSView(frame: CGRectZero)
        self.circleView.layer?.backgroundColor = NSColor.NFXGray44Color().CGColor
        self.circleView.layer?.cornerRadius = 4
        self.circleView.alphaValue = 0.2
        self.addSubview(self.circleView)

        self.leftSeparator = NSView(frame: CGRectZero)
        self.leftSeparator.layer?.backgroundColor = NSColor.whiteColor().CGColor
        self.addSubview(self.leftSeparator)

        self.rightSeparator = NSView(frame: CGRectZero)
        self.rightSeparator.layer?.backgroundColor = NSColor.NFXLightGrayColor().CGColor
        self.addSubview(self.rightSeparator)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubtreeIfNeeded() {
        super.layoutSubtreeIfNeeded()
        
        self.statusView.frame = CGRectMake(0, 0, 50, frame.height - 1)
        
        self.requestTimeLabel.frame = CGRectMake(0, 13, CGRectGetWidth(statusView.frame), 14)
        
        self.timeIntervalLabel.frame = CGRectMake(0, CGRectGetMaxY(requestTimeLabel.frame) + 5, CGRectGetWidth(statusView.frame), 14)
        
        self.URLLabel.frame = CGRectMake(CGRectGetMaxX(statusView.frame) + padding, 0, frame.width - CGRectGetMinX(URLLabel.frame) - 25 - padding, 40)
        self.URLLabel.autoresizingMask = .ViewWidthSizable
        
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
        self.URLLabel.stringValue = url
    }
    
    func setStatus(status: Int)
    {
        if status == 999 {
            self.statusView.layer?.backgroundColor = NFXColor.NFXGray44Color().CGColor //gray
            self.timeIntervalLabel.textColor = NFXColor.whiteColor()
            
        } else if status < 400 {
            self.statusView.layer?.backgroundColor = NFXColor.NFXGreenColor().CGColor //green
            self.timeIntervalLabel.textColor = NFXColor.NFXDarkGreenColor()
            
        } else {
            self.statusView.layer?.backgroundColor = NFXColor.NFXRedColor().CGColor //red
            self.timeIntervalLabel.textColor = NFXColor.NFXDarkRedColor()
            
        }
    }
    
    func setRequestTime(requestTime: String)
    {
        self.requestTimeLabel.stringValue = requestTime
    }
    
    func setTimeInterval(timeInterval: Float)
    {
        if timeInterval == 999 {
            self.timeIntervalLabel.stringValue = "-"
        } else {
            self.timeIntervalLabel.stringValue = NSString(format: "%.2f", timeInterval) as String
        }
    }
    
    func setType(type: String)
    {
        self.typeLabel.stringValue = type
    }
    
    func setMethod(method: String)
    {
        self.methodLabel.stringValue = method
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

#endif