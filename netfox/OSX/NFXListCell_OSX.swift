//
//  NFXListCell_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa

class NFXListCell_OSX: NSTableCellView {
    
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
        
        circleView.layer?.backgroundColor = NSColor.NFXGray44Color().cgColor
        circleView.layer?.cornerRadius = 4
        circleView.alphaValue = 0.2
        
        requestTimeLabel.font = NSFont.NFXFontBold(size: 13)
        timeIntervalLabel.font = NSFont.NFXFont(size: 12)
        URLLabel.font = NSFont.NFXFont(size: 12)
        methodLabel.font = NSFont.NFXFont(size: 12)
        typeLabel.font = NSFont.NFXFont(size: 12)
        
    }
        
    func isNew() {
        circleView.isHidden = false
    }
    
    func isOld() {
        circleView.isHidden = true
    }
    
    func configForObject(obj: NFXHTTPModel) {
        setURL(url: obj.requestURL ?? "-")
        setStatus(status: obj.responseStatus ?? 999)
        setTimeInterval(timeInterval: obj.timeInterval ?? 999)
        setRequestTime(requestTime: obj.requestTime ?? "-")
        setType(type: obj.responseType ?? "-")
        setMethod(method: obj.requestMethod ?? "-")
        isNewBasedOnDate(responseDate: obj.responseDate as NSDate? ?? NSDate())
    }
    
    func setURL(url: String) {
        URLLabel.stringValue = url
    }
    
    func setStatus(status: Int) {
        if status == 999 {
            statusView.layer?.backgroundColor = NFXColor.NFXGray44Color().cgColor //gray
            timeIntervalLabel.textColor = NFXColor.white
            
        } else if status < 400 {
            statusView.layer?.backgroundColor = NFXColor.NFXGreenColor().cgColor //green
            timeIntervalLabel.textColor = NFXColor.NFXDarkGreenColor()
            
        } else {
            statusView.layer?.backgroundColor = NFXColor.NFXRedColor().cgColor //red
            timeIntervalLabel.textColor = NFXColor.NFXDarkRedColor()
            
        }
    }
    
    func setRequestTime(requestTime: String) {
        requestTimeLabel.stringValue = requestTime
    }
    
    func setTimeInterval(timeInterval: Float) {
        if timeInterval == 999 {
            timeIntervalLabel.stringValue = "-"
        } else {
            timeIntervalLabel.stringValue = NSString(format: "%.2f", timeInterval) as String
        }
    }
    
    func setType(type: String) {
        typeLabel.stringValue = type
    }
    
    func setMethod(method: String) {
        methodLabel.stringValue = method
    }
    
    func isNewBasedOnDate(responseDate: NSDate) {
        if responseDate.isGreaterThan(NFX.sharedInstance().getLastVisitDate()) {
            isNew()
        } else {
            isOld()
        }
    }
}

#endif
