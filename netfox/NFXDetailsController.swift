//
//  NFXDetailsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class NFXDetailsController: NFXGenericController, MFMailComposeViewControllerDelegate
{
    var infoButton: UIButton = UIButton()
    var requestButton: UIButton = UIButton()
    var responseButton: UIButton = UIButton()

    var infoView: UIScrollView = UIScrollView()
    var requestView: UIScrollView = UIScrollView()
    var responseView: UIScrollView = UIScrollView()
    
    enum EDetailsView
    {
        case INFO
        case REQUEST
        case RESPONSE
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Details"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("actionButtonPressed:"))
        
        self.infoButton = createHeaderButton("Info", x: 0, selector: Selector("infoButtonPressed"))
        self.view.addSubview(self.infoButton)
        
        self.requestButton = createHeaderButton("Request", x: CGRectGetMaxX(self.infoButton.frame), selector: Selector("requestButtonPressed"))
        self.view.addSubview(self.requestButton)
        
        self.responseButton = createHeaderButton("Response", x: CGRectGetMaxX(self.requestButton.frame), selector: Selector("responseButtonPressed"))
        self.view.addSubview(self.responseButton)

        self.infoView = createDetailsView(getInfoStringFromObject(self.selectedModel), forView: .INFO)
        self.view.addSubview(self.infoView)
        
        self.requestView = createDetailsView(getRequestStringFromObject(self.selectedModel), forView: .REQUEST)
        self.view.addSubview(self.requestView)

        self.responseView = createDetailsView(getResponseStringFromObject(self.selectedModel), forView: .RESPONSE)
        self.view.addSubview(self.responseView)
        
        infoButtonPressed()
        
    }
    
    
    func createHeaderButton(title: String, x: CGFloat, selector: Selector) -> UIButton
    {
        var tempButton: UIButton
        tempButton = UIButton()
        tempButton.frame = CGRectMake(x, 0, CGRectGetWidth(self.view.frame) / 3, 44)
        tempButton.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleWidth]
        tempButton.backgroundColor = UIColor.NFXDarkStarkWhiteColor()
        tempButton.setTitle(title, forState: .Normal)
        tempButton.setTitleColor(UIColor.init(netHex: 0x6d6d6d), forState: .Normal)
        tempButton.setTitleColor(UIColor.init(netHex: 0xf3f3f4), forState: .Selected)
        tempButton.titleLabel?.font = UIFont.NFXFont(15)
        tempButton.addTarget(self, action: selector, forControlEvents: .TouchUpInside)
        return tempButton
    }
    
    func createDetailsView(content: NSAttributedString, forView: EDetailsView) -> UIScrollView
    {
        var scrollView: UIScrollView
        scrollView = UIScrollView()
        scrollView.frame = CGRectMake(0, 44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        scrollView.autoresizesSubviews = true
        scrollView.backgroundColor = UIColor.clearColor()
        
        var textLabel: UILabel
        textLabel = UILabel()
        textLabel.frame = CGRectMake(20, 20, CGRectGetWidth(scrollView.frame) - 40, CGRectGetHeight(scrollView.frame) - 20);
        textLabel.font = UIFont.NFXFont(13)
        textLabel.textColor = UIColor.NFXGray44Color()
        textLabel.numberOfLines = 0
        textLabel.attributedText = content
        textLabel.sizeToFit()
		textLabel.textAlignment = .Left
        scrollView.addSubview(textLabel)
        
        var moreButton: UIButton
        moreButton = UIButton.init(frame: CGRectMake(20, CGRectGetMaxY(textLabel.frame) + 10, CGRectGetWidth(scrollView.frame) - 40, 40))
        moreButton.backgroundColor = UIColor.NFXGray44Color()
        
        if ((forView == EDetailsView.REQUEST) && (self.selectedModel.requestBodyLength > 1024)) {
            moreButton.setTitle("Show request body", forState: .Normal)
            moreButton.addTarget(self, action: Selector("requestBodyButtonPressed"), forControlEvents: .TouchUpInside)
            scrollView.addSubview(moreButton)
            scrollView.contentSize = CGSizeMake(textLabel.frame.width, CGRectGetMaxY(moreButton.frame))

        } else if ((forView == EDetailsView.RESPONSE) && (self.selectedModel.responseBodyLength > 1024)) {
            moreButton.setTitle("Show response body", forState: .Normal)
            moreButton.addTarget(self, action: Selector("responseBodyButtonPressed"), forControlEvents: .TouchUpInside)
            scrollView.addSubview(moreButton)
            scrollView.contentSize = CGSizeMake(textLabel.frame.width, CGRectGetMaxY(moreButton.frame))
            
        } else {
            scrollView.contentSize = CGSizeMake(textLabel.frame.width, CGRectGetMaxY(textLabel.frame))
        }
        
        return scrollView
    }
    
    func actionButtonPressed(sender: UIBarButtonItem)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "Share", message: "", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        
        let simpleLog: UIAlertAction = UIAlertAction(title: "Simple log", style: .Default) { action -> Void in
            self.sendMailWithBodies(false)
        }
        actionSheetController.addAction(simpleLog)
        
        let fullLogAction: UIAlertAction = UIAlertAction(title: "Full log", style: .Default) { action -> Void in
            self.sendMailWithBodies(true)
        }
        actionSheetController.addAction(fullLogAction)
        
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    func infoButtonPressed()
    {
        buttonPressed(self.infoButton)
    }
    
    func requestButtonPressed()
    {
        buttonPressed(self.requestButton)
    }
    
    func responseButtonPressed()
    {
        buttonPressed(self.responseButton)
    }
    
    func buttonPressed(button: UIButton)
    {
        self.infoButton.selected = false
        self.requestButton.selected = false
        self.responseButton.selected = false
        
        self.infoView.hidden = true
        self.requestView.hidden = true
        self.responseView.hidden = true
        
        if button == self.infoButton {
            self.infoButton.selected = true
            self.infoView.hidden = false
            
        } else if button == requestButton {
            self.requestButton.selected = true
            self.requestView.hidden = false
            
        } else if button == responseButton {
            self.responseButton.selected = true
            self.responseView.hidden = false
            
        }
    }
    
    
    func responseBodyButtonPressed()
    {
        bodyButtonPressed().bodyType = NFXBodyType.RESPONSE
    }
    
    func requestBodyButtonPressed()
    {
        bodyButtonPressed().bodyType = NFXBodyType.REQUEST
    }
    
    func bodyButtonPressed() -> NFXGenericBodyDetailsController {
        
        var bodyDetailsController: NFXGenericBodyDetailsController
        
        if self.selectedModel.shortType == HTTPModelShortType.IMAGE.rawValue {
            bodyDetailsController = NFXImageBodyDetailsController()
        } else {
            bodyDetailsController = NFXRawBodyDetailsController()
        }
        bodyDetailsController.selectedModel(self.selectedModel)
        self.navigationController?.pushViewController(bodyDetailsController, animated: true)
        return bodyDetailsController
    }
    
    
    func getInfoStringFromObject(object: NFXHTTPModel) -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
        tempString += "[URL] \n\(object.requestURL!)\n\n"
        tempString += "[Method] \n\(object.requestMethod!)\n\n"
        if !(object.noResponse) {
            tempString += "[Status] \n\(object.responseStatus!)\n\n"
        }
        tempString += "[Request date] \n\(object.requestDate!)\n\n"
        if !(object.noResponse) {
            tempString += "[Response date] \n\(object.responseDate!)\n\n"
            tempString += "[Time interval] \n\(object.timeInterval!)\n\n"
        }
        tempString += "[Timeout] \n\(object.requestTimeout!)\n\n"
        tempString += "[Cache policy] \n\(object.requestCachePolicy!)\n\n"
        
        return formatNFXString(tempString)
    }
    
    func getRequestStringFromObject(object: NFXHTTPModel) -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
        tempString += "-- Headers --\n\n"

        if object.requestHeaders?.count > 0 {
            for (key, val) in (object.requestHeaders)! {
                tempString += "[\(key)] \n\(val)\n\n"
            }
        } else {
            tempString += "Request headers are empty\n\n"
        }

        
        tempString += "\n-- Body --\n\n"

        if (object.requestBodyLength == 0) {
            tempString += "Request body is empty\n"
        } else if (object.requestBodyLength > 1024) {
            tempString += "Too long to show. If you want to see it, please tap the following button\n"
        } else {
            tempString += "\(object.getRequestBody())\n"
        }
        
        return formatNFXString(tempString)
    }
    
    func getResponseStringFromObject(object: NFXHTTPModel) -> NSAttributedString
    {
        if (object.noResponse) {
            return NSMutableAttributedString(string: "No response")
        }
        
        var tempString: String
        tempString = String()
        
        tempString += "-- Headers --\n\n"

        if object.responseHeaders?.count > 0 {
            for (key, val) in object.responseHeaders! {
                tempString += "[\(key)] \n\(val)\n\n"
            }
        } else {
            tempString += "Response headers are empty\n\n"
        }


        tempString += "\n-- Body --\n\n"

        if (object.responseBodyLength == 0) {
            tempString += "Response body is empty\n"
        } else if (object.responseBodyLength > 1024) {
            tempString += "Too long to show. If you want to see it, please tap the following button\n"
        } else {
            tempString += "\(object.getResponseBody())\n"
        }
        
        return formatNFXString(tempString)
    }
    
    func sendMailWithBodies(bodies: Bool)
    {
        if (MFMailComposeViewController.canSendMail()) {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            var tempString: String
            tempString = String()
            
            
            tempString += "** INFO **\n"
            tempString += "\(getInfoStringFromObject(self.selectedModel).string)\n\n"
            
            tempString += "** REQUEST **\n"
            tempString += "\(getRequestStringFromObject(self.selectedModel).string)\n\n"
            
            tempString += "** RESPONSE **\n"
            tempString += "\(getResponseStringFromObject(self.selectedModel).string)\n\n"
            
            tempString += "logged via netfox - [https://github.com/kasketis/netfox]\n"
            
            mailComposer.setSubject("netfox log - \(self.selectedModel.requestURL!)")
            mailComposer.setMessageBody(tempString, isHTML: false)
            
            if bodies {
                let requestFilePath = self.selectedModel.getRequestBodyFilepath()
                if let requestFileData = NSData(contentsOfFile: requestFilePath as String) {
                    mailComposer.addAttachmentData(requestFileData, mimeType: "text/plain", fileName: "request-body")
                }
                
                let responseFilePath = self.selectedModel.getResponseBodyFilepath()
                if let responseFileData = NSData(contentsOfFile: responseFilePath as String) {
                    mailComposer.addAttachmentData(responseFileData, mimeType: "text/plain", fileName: "response-body")
                }
            }

            self.presentViewController(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

