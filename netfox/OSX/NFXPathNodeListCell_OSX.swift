//
//  NFXPathNodeListCell_OSX.swift
//  netfox_ios
//
//  Created by Ștefan Suciu on 2/6/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

#if os(OSX)
    
import Cocoa
    
let folderImage = NFXImage.NFXFolder()
    
class NFXPathNodeListCell_OSX: NSTableCellView {
    
    @IBOutlet var statusView: NSView!
    @IBOutlet var URLLabel: NSTextField!
    @IBOutlet var _imageView: NSImageView!
    
    @IBOutlet var circleView: NSView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    let padding: CGFloat = 5
    
    // MARK: Life cycle
    
    override func awakeFromNib() {
        layer?.backgroundColor = NFXColor.clear.cgColor
        
        self.circleView.layer?.backgroundColor = NSColor.NFXGray44Color().cgColor
        self.circleView.layer?.cornerRadius = 4
        self.circleView.alphaValue = 0.2
        self.URLLabel.font = NSFont.NFXFont(size: 12)
    }
    
    func isNew() {
        self.circleView.isHidden = false
    }
    
    func isOld() {
        self.circleView.isHidden = true
    }
    
    func configForObject(obj: NFXPathNode) {
        leadingConstraint.constant = CGFloat(obj.depth()) * 16.0
        
        self.URLLabel.stringValue = obj.name
        
        guard let httpModel = obj.httpModel else {
            self.statusView.layer?.backgroundColor = NSColor.clear.cgColor
            self._imageView.image = folderImage
            return
        }
        
        self._imageView.image = nil
        configForObject(obj: httpModel)
    }
    
    func configForObject(obj: NFXHTTPModel) {
        setStatus(status: obj.responseStatus ?? 999)
        isNewBasedOnDate(responseDate: obj.responseDate as NSDate? ?? NSDate())
    }
    
    func setStatus(status: Int) {
        if status == 999 {
            self.statusView.layer?.backgroundColor = NFXColor.NFXGray44Color().cgColor //gray
            
        } else if status < 400 {
            self.statusView.layer?.backgroundColor = NFXColor.NFXGreenColor().cgColor //green
            
        } else {
            self.statusView.layer?.backgroundColor = NFXColor.NFXRedColor().cgColor //red
        }
    }
    
    func isNewBasedOnDate(responseDate: NSDate) {
        if responseDate.isGreaterThan(NFX.sharedInstance().getLastVisitDate()) {
            self.isNew()
        } else {
            self.isOld()
        }
    }
}
    
#endif
