//
//  NFXDetailsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class NFXDetailsController : UIViewController, MFMailComposeViewControllerDelegate, UIActionSheetDelegate
{
    var iIndex: Int = 0

    var infoButton: UIButton = UIButton()
    var requestButton: UIButton = UIButton()
    var responseButton: UIButton = UIButton()

    var infoView: UIScrollView = UIScrollView()
    var requestView: UIScrollView = UIScrollView()
    var responseView: UIScrollView = UIScrollView()
    
    let headerButtonNormalColor = 0x9b958d
    let headerButtonSelectedColor = 0x9b958d
    
    enum EDetailsView
    {
        case eDetailsViewInfo
        case eDetailsViewRequest
        case eDetailsViewResponse
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        self.title = "Details"
        
        self.view.backgroundColor = UIColor.init(netHex: 0xf2f2f2)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("actionButtonPressed"))
        
        self.infoButton = createHeaderButton("Info", x: 0, selector: Selector("infoButtonPressed"))
        self.view.addSubview(self.infoButton)
        
        self.requestButton = createHeaderButton("Request", x: CGRectGetMaxX(self.infoButton.frame), selector: Selector("requestButtonPressed"))
        self.view.addSubview(self.requestButton)
        
        self.responseButton = createHeaderButton("Response", x: CGRectGetMaxX(self.requestButton.frame), selector: Selector("responseButtonPressed"))
        self.view.addSubview(self.responseButton)

        
        let tempObject = NFXHTTPModelManager.sharedInstance.models[self.iIndex]


        self.infoView = createDetailsView(getInfoStringFromObject(tempObject), forView: .eDetailsViewInfo)
        self.view.addSubview(self.infoView)
        
        self.requestView = createDetailsView(getRequestStringFromObject(tempObject), forView: .eDetailsViewRequest)
        self.view.addSubview(self.requestView)

        self.responseView = createDetailsView(getResponseStringFromObject(tempObject), forView: .eDetailsViewResponse)
        self.view.addSubview(self.responseView)
        
        infoButtonPressed()
        
    }
    
    
    func createHeaderButton(title: String, x: CGFloat, selector: Selector) -> UIButton
    {
        var tempButton: UIButton
        tempButton = UIButton()
        tempButton.frame = CGRectMake(x, 0, CGRectGetWidth(self.view.frame) / 3, 44)
        tempButton.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleWidth]
        tempButton.backgroundColor = UIColor.init(netHex: headerButtonNormalColor)
        tempButton.setTitle(title, forState: .Normal)
        tempButton.setTitleColor(UIColor.init(netHex: 0x6d6d6d), forState: .Normal)
        tempButton.setTitleColor(UIColor.init(netHex: 0xf3f3f4), forState: .Selected)
        tempButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
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
        textLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(11))
        textLabel.textColor = UIColor.init(netHex: 0x707070)
        textLabel.numberOfLines = 0
        textLabel.attributedText = content
        textLabel.sizeToFit()
        scrollView.addSubview(textLabel)
        
        let tempObject = NFXHTTPModelManager.sharedInstance.models[self.iIndex]

        var moreButton: UIButton
        moreButton = UIButton.init(frame: CGRectMake(20, CGRectGetMaxY(textLabel.frame) + 10, CGRectGetWidth(scrollView.frame) - 40, 40))
        moreButton.backgroundColor = UIColor.init(netHex: 0x707070)
        
        if ((forView == EDetailsView.eDetailsViewRequest) && (tempObject.requestBodyLength > 1024)) {
            moreButton.setTitle("Show request body", forState: .Normal)
            moreButton.addTarget(self, action: Selector("requestBodyButtonPressed"), forControlEvents: .TouchUpInside)
            scrollView.addSubview(moreButton)
            scrollView.contentSize = CGSizeMake(textLabel.frame.width, CGRectGetMaxY(moreButton.frame))

        } else if ((forView == EDetailsView.eDetailsViewResponse) && (tempObject.responseBodyLength > 1024)) {
            moreButton.setTitle("Show response body", forState: .Normal)
            moreButton.addTarget(self, action: Selector("responseBodyButtonPressed"), forControlEvents: .TouchUpInside)
            scrollView.addSubview(moreButton)
            scrollView.contentSize = CGSizeMake(textLabel.frame.width, CGRectGetMaxY(moreButton.frame))
            
        } else {
            scrollView.contentSize = CGSizeMake(textLabel.frame.width, CGRectGetMaxY(textLabel.frame))
        }
        
        return scrollView
    }
    
    func actionButtonPressed()
    {
        var actionSheet: UIActionSheet
        actionSheet = UIActionSheet()
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.addButtonWithTitle("Simple log")
        actionSheet.addButtonWithTitle("Full log")
        actionSheet.cancelButtonIndex = 0
        actionSheet.showInView(self.view)
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
    
    func responseBodyButtonPressed()
    {
        var bodyDetailsController : NFXBodyDetailsController
        bodyDetailsController = NFXBodyDetailsController()
        bodyDetailsController.iIndex = self.iIndex
        self.navigationController?.pushViewController(bodyDetailsController, animated: true)
    }
    
    func buttonPressed(button: UIButton)
    {
        self.infoButton.selected = false
        self.requestButton.selected = false
        self.responseButton.selected = false
        
        self.infoView.hidden = true
        self.requestView.hidden = true
        self.responseView.hidden = true
        
        self.infoButton.backgroundColor = UIColor.init(netHex: headerButtonNormalColor)
        self.requestButton.backgroundColor = UIColor.init(netHex: headerButtonNormalColor)
        self.responseButton.backgroundColor = UIColor.init(netHex: headerButtonNormalColor)

        if button == self.infoButton {
            self.infoButton.selected = true
            self.infoButton.backgroundColor = UIColor.init(netHex: headerButtonSelectedColor)
            self.infoView.hidden = false
            
        } else if button == requestButton {
            self.requestButton.selected = true
            self.requestButton.backgroundColor = UIColor.init(netHex: headerButtonSelectedColor)
            self.requestView.hidden = false
            
        } else if button == responseButton {
            self.responseButton.selected = true
            self.responseButton.backgroundColor = UIColor.init(netHex: headerButtonSelectedColor)
            self.responseView.hidden = false

        }
    }
    
    func getInfoStringFromObject(object: NFXHTTPModel) -> NSAttributedString
    {

        var tempString: String
        tempString = String()
        
        tempString += "[URL] \n\(object.requestURL!)\n\n"
        tempString += "[Method] \n\(object.requestMethod!)\n\n"
        tempString += "[Status] \n\(object.responseStatus!)\n\n"
        tempString += "[Request date] \n\(object.requestDate!)\n\n"
        tempString += "[Response date] \n\(object.responseDate!)\n\n"
        tempString += "[Time interval] \n\(object.timeInterval!)\n\n"
        tempString += "[Timeout] \n\(object.requestTimeout!)\n\n"
        tempString += "[Cache policy] \n\(object.requestCachePolicy!)\n\n"
        
        return formatString(tempString)
    }
    
    func getRequestStringFromObject(object: NFXHTTPModel) -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
//        tempString += "[                                     Headers                                      ]\n\n"
        tempString += "-- Headers --\n\n"

        if object.requestHeaders?.count > 0 {
            for (key, val) in (object.requestHeaders)! {
                tempString += "[\(key)] \n\(val)\n\n"
            }
        } else {
            tempString += "Request headers are empty\n\n"
        }

//        tempString += "\n[                                       Body                                         ]\n\n"
        tempString += "\n-- Body --\n\n"

        if (object.requestBodyLength == 0) {
            tempString += "Request body is empty\n"
        } else if (object.requestBodyLength > 1024) {
            tempString += "Too long to show. If you want to see it, please tap the following button\n"
        } else {
            tempString += "\(object.getRequestBody())\n"
        }
        
        return formatString(tempString)
    }
    
    func getResponseStringFromObject(object: NFXHTTPModel) -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
//        tempString += "[                                     Headers                                      ]\n\n"
        tempString += "-- Headers --\n\n"

        if object.responseHeaders?.count > 0 {
            for (key, val) in object.responseHeaders! {
                tempString += "[\(key)] \n\(val)\n\n"
            }
        } else {
            tempString += "Response headers are empty\n\n"
        }


//        tempString += "\n[                                       Body                                         ]\n\n"
        tempString += "\n-- Body --\n\n"

        if (object.responseBodyLength == 0) {
            tempString += "Response body is empty\n"
        } else if (object.responseBodyLength > 1024) {
            tempString += "Too long to show. If you want to see it, please tap the following button\n"
        } else {
            tempString += "\(object.getResponseBody())\n"
        }
        
        return formatString(tempString)
    }
    
    
    func formatString(string: String) -> NSAttributedString
    {
        let l = string.characters.count

        let regex1 = try! NSRegularExpression(pattern: "\\--.+?\\--", options: NSRegularExpressionOptions.CaseInsensitive)
        
        
        let matches1 = regex1.matchesInString(string, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<NSTextCheckingResult>
        
        var tempMutableString = NSMutableAttributedString()
        
        tempMutableString = NSMutableAttributedString(string: string)
        
        for match in matches1 {
            tempMutableString.addAttribute(NSFontAttributeName, value: UIFont.init(name: "HelveticaNeue-Bold", size: 13)!, range: match.range)
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(netHex: 0xec5e28), range: match.range)
        }
        
        
        let regex2 = try! NSRegularExpression(pattern: "\\[.+?\\]", options: NSRegularExpressionOptions.CaseInsensitive)
        
        
        let matches2 = regex2.matchesInString(string, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, l)) as Array<NSTextCheckingResult>
        

        for match in matches2 {
            tempMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(netHex: 0x231f20), range: match.range)
        }

        
        return tempMutableString
    }
    
    func sendMailWithBodies(bodies: Bool)
    {
        if (MFMailComposeViewController.canSendMail()) {
            
            let tempObject = NFXHTTPModelManager.sharedInstance.models[self.iIndex]
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            var tempString: String
            tempString = String()
            
            
            tempString += "** INFO **\n"
            tempString += "\(getInfoStringFromObject(tempObject).string)\n\n"
            
            tempString += "** REQUEST **\n"
            tempString += "\(getRequestStringFromObject(tempObject).string)\n\n"
            
            tempString += "** RESPONSE **\n"
            tempString += "\(getResponseStringFromObject(tempObject).string)\n\n"
            
            tempString += "logged via netfox - [https://github.com/kasketis/netfox]\n"
            
            mailComposer.setSubject("netfox log - \(tempObject.requestURL!)")
            mailComposer.setMessageBody(tempString, isHTML: false)
            
            if bodies {
                let requestFilePath = tempObject.getRequestBodyFilepath()
                if let requestFileData = NSData(contentsOfFile: requestFilePath as String) {
                    mailComposer.addAttachmentData(requestFileData, mimeType: "text/plain", fileName: "request-body")
                }
                
                let responseFilePath = tempObject.getResponseBodyFilepath()
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
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if buttonIndex == 1 {
            self.sendMailWithBodies(false)
            
        } else if buttonIndex == 2 {
            self.sendMailWithBodies(true)
        }
    }
    
}

