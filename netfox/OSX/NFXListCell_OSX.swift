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
        layer?.backgroundColor = NFXColor.clear.cgColor
        
        self.circleView.layer?.backgroundColor = NSColor.NFXGray44Color().cgColor
        self.circleView.layer?.cornerRadius = 4
        self.circleView.alphaValue = 0.2
        
        self.requestTimeLabel.font = NSFont.NFXFontBold(size: 13)
        self.timeIntervalLabel.font = NSFont.NFXFont(size: 12)
        self.URLLabel.font = NSFont.NFXFont(size: 12)
        self.methodLabel.font = NSFont.NFXFont(size: 12)
        self.typeLabel.font = NSFont.NFXFont(size: 12)
        
    }
        
    func isNew()
    {
        self.circleView.isHidden = false
    }
    
    func isOld()
    {
        self.circleView.isHidden = true
    }
    
    func configForObject(obj: NFXHTTPModel)
    {
        setURL(url: obj.requestURL ?? "-")
        setStatus(status: obj.responseStatus ?? 999)
        setTimeInterval(timeInterval: obj.timeInterval ?? 999)
        setRequestTime(requestTime: obj.requestTime ?? "-")
        setType(type: obj.responseType ?? "-")
        setMethod(method: obj.requestMethod ?? "-")
        isNewBasedOnDate(responseDate: obj.responseDate as NSDate? ?? NSDate())
    }
    
    func setURL(url: String)
    {
        self.URLLabel.stringValue = url
    }
    
    func setStatus(status: Int)
    {
        if status == 999 {
            self.statusView.layer?.backgroundColor = NFXColor.NFXGray44Color().cgColor //gray
            self.timeIntervalLabel.textColor = NFXColor.white
            
        } else if status < 400 {
            self.statusView.layer?.backgroundColor = NFXColor.NFXGreenColor().cgColor //green
            self.timeIntervalLabel.textColor = NFXColor.NFXDarkGreenColor()
            
        } else {
            self.statusView.layer?.backgroundColor = NFXColor.NFXRedColor().cgColor //red
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
        if responseDate.isGreaterThan(NFX.sharedInstance().getLastVisitDate()) {
            self.isNew()
        } else {
            self.isOld()
        }
    }
}

#endif
