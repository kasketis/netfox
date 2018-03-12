//
//  NFXPathNodeListCell_OSX.swift
//  netfox_ios
//
//  Created by Ștefan Suciu on 2/6/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

#if os(OSX)
    
import Cocoa
    
let cloudImage = NFXImage.cloud
let folderImage = NFXImage.folder
let fileDownloadingImage = NFXImage.fileDownloading
let fileSuccessImage = NFXImage.fileSuccess
let fileWarningImage = NFXImage.fileWarning
let fileUnauthorizedImage = NFXImage.fileUnauthorized
let serverErrorImage = NFXImage.serverError
    
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
        
        circleView.layer?.backgroundColor = NSColor.NFXGray44Color().cgColor
        circleView.layer?.cornerRadius = 4
        circleView.alphaValue = 0.2
        URLLabel.font = NSFont.NFXFont(size: 12)
    }
    
    func isNew() {
        circleView.isHidden = false
    }
    
    func isOld() {
        circleView.isHidden = true
    }
    
    func configForObject(obj: NFXPathNode) {
        leadingConstraint.constant = CGFloat(obj.depth()) * 16.0
        URLLabel.stringValue = obj.name
        
        if let httpModel = obj.httpModel {
            configForObject(obj: httpModel)
        } else if obj.parent?.parent == nil {
            _imageView.image = cloudImage
        } else {
            _imageView.image = folderImage
        }
    }
    
    func configForObject(obj: NFXHTTPModel) {
        setStatus(status: obj.responseStatus)
        isNewBasedOnDate(responseDate: obj.responseDate as NSDate? ?? NSDate())
    }
    
    func setStatus(status: Int?) {
        guard let status = status else {
            _imageView.image = fileWarningImage
            return
        }
        
        if status >= 200 && status < 300 {
            _imageView.image = fileSuccessImage
        } else if status >= 400 && status < 500 {
            if status == 403 {
                _imageView.image = fileUnauthorizedImage
            } else {
                _imageView.image = fileWarningImage
            }
        } else if status >= 500 && status < 600 {
            _imageView.image = serverErrorImage
        } else {
            _imageView.image = fileDownloadingImage
        }
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
