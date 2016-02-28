//
//  NFXListCell_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa

class NFXListCell_OSX: NSTableCellView 
{
    
    @IBOutlet var statusView: NSView!
    @IBOutlet var requestTimeLabel: NSTextField!
    @IBOutlet var timeIntervalLabel: NSTextField!
    
    @IBOutlet var URLLabel: NSTextField!
    @IBOutlet var methodLabel: NSTextField!
    @IBOutlet var typeLabel: NSTextField!
    
    @IBOutlet var circleView: NSView!

    let padding: CGFloat = 5
    
    // MARK: Life cycle
        
    override func awakeFromNib() {
        layer?.backgroundColor = NFXColor.clearColor().CGColor
        
        self.circleView.layer?.backgroundColor = NSColor.NFXGray44Color().CGColor
        self.circleView.layer?.cornerRadius = 4
        self.circleView.alphaValue = 0.2
        
        self.requestTimeLabel.font = NSFont.NFXFontBold(13)
        self.timeIntervalLabel.font = NSFont.NFXFont(12)
        self.URLLabel.font = NSFont.NFXFont(12)
        self.methodLabel.font = NSFont.NFXFont(12)
        self.typeLabel.font = NSFont.NFXFont(12)
        
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