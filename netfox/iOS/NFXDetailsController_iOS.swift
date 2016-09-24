//
//  NFXDetailsController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)
    
import Foundation
import UIKit
import MessageUI
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class NFXDetailsController_iOS: NFXDetailsController, MFMailComposeViewControllerDelegate
{
    var infoButton: UIButton = UIButton()
    var requestButton: UIButton = UIButton()
    var responseButton: UIButton = UIButton()

    var infoView: UIScrollView = UIScrollView()
    var requestView: UIScrollView = UIScrollView()
    var responseView: UIScrollView = UIScrollView()
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Details"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(NFXDetailsController_iOS.actionButtonPressed(_:)))
        
        self.infoButton = createHeaderButton("Info", x: 0, selector: #selector(NFXDetailsController_iOS.infoButtonPressed))
        self.view.addSubview(self.infoButton)
        
        self.requestButton = createHeaderButton("Request", x: self.infoButton.frame.maxX, selector: #selector(NFXDetailsController_iOS.requestButtonPressed))
        self.view.addSubview(self.requestButton)
        
        self.responseButton = createHeaderButton("Response", x: self.requestButton.frame.maxX, selector: #selector(NFXDetailsController_iOS.responseButtonPressed))
        self.view.addSubview(self.responseButton)
        
        self.infoView = createDetailsView(getInfoStringFromObject(self.selectedModel), forView: .info)
        self.view.addSubview(self.infoView)
        
        self.requestView = createDetailsView(getRequestStringFromObject(self.selectedModel), forView: .request)
        self.view.addSubview(self.requestView)
        
        self.responseView = createDetailsView(getResponseStringFromObject(self.selectedModel), forView: .response)
        self.view.addSubview(self.responseView)
        
        infoButtonPressed()
        
    }
    
    func createHeaderButton(_ title: String, x: CGFloat, selector: Selector) -> UIButton
    {
        var tempButton: UIButton
        tempButton = UIButton()
        tempButton.frame = CGRect(x: x, y: 0, width: self.view.frame.width / 3, height: 44)
        tempButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        tempButton.backgroundColor = UIColor.NFXDarkStarkWhiteColor()
        tempButton.setTitle(title, for: UIControlState())
        tempButton.setTitleColor(UIColor.init(netHex: 0x6d6d6d), for: UIControlState())
        tempButton.setTitleColor(UIColor.init(netHex: 0xf3f3f4), for: .selected)
        tempButton.titleLabel?.font = UIFont.NFXFont(15)
        tempButton.addTarget(self, action: selector, for: .touchUpInside)
        return tempButton
    }
    
    func createDetailsView(_ content: NSAttributedString, forView: EDetailsView) -> UIScrollView
    {
        var scrollView: UIScrollView
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height - 44)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.autoresizesSubviews = true
        scrollView.backgroundColor = UIColor.clear
        
        var textLabel: UILabel
        textLabel = UILabel()
        textLabel.frame = CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20);
        textLabel.font = UIFont.NFXFont(13)
        textLabel.textColor = UIColor.NFXGray44Color()
        textLabel.numberOfLines = 0
        textLabel.attributedText = content
        textLabel.sizeToFit()
        scrollView.addSubview(textLabel)
        
        var moreButton: UIButton
        moreButton = UIButton.init(frame: CGRect(x: 20, y: textLabel.frame.maxY + 10, width: scrollView.frame.width - 40, height: 40))
        moreButton.backgroundColor = UIColor.NFXGray44Color()
        
        if ((forView == EDetailsView.request) && (self.selectedModel.requestBodyLength > 1024)) {
            moreButton.setTitle("Show request body", for: UIControlState())
            moreButton.addTarget(self, action: #selector(NFXDetailsController_iOS.requestBodyButtonPressed), for: .touchUpInside)
            scrollView.addSubview(moreButton)
            scrollView.contentSize = CGSize(width: textLabel.frame.width, height: moreButton.frame.maxY)

        } else if ((forView == EDetailsView.response) && (self.selectedModel.responseBodyLength > 1024)) {
            moreButton.setTitle("Show response body", for: UIControlState())
            moreButton.addTarget(self, action: #selector(NFXDetailsController_iOS.responseBodyButtonPressed), for: .touchUpInside)
            scrollView.addSubview(moreButton)
            scrollView.contentSize = CGSize(width: textLabel.frame.width, height: moreButton.frame.maxY)
            
        } else {
            scrollView.contentSize = CGSize(width: textLabel.frame.width, height: textLabel.frame.maxY)
        }
        
        return scrollView
    }
    
    func actionButtonPressed(_ sender: UIBarButtonItem)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "Share", message: "", preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        
        let simpleLog: UIAlertAction = UIAlertAction(title: "Simple log", style: .default) { action -> Void in
            self.sendMailWithBodies(false)
        }
        actionSheetController.addAction(simpleLog)
        
        let fullLogAction: UIAlertAction = UIAlertAction(title: "Full log", style: .default) { action -> Void in
            self.sendMailWithBodies(true)
        }
        actionSheetController.addAction(fullLogAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
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
    
    func buttonPressed(_ button: UIButton)
    {
        self.infoButton.isSelected = false
        self.requestButton.isSelected = false
        self.responseButton.isSelected = false
        
        self.infoView.isHidden = true
        self.requestView.isHidden = true
        self.responseView.isHidden = true
        
        if button == self.infoButton {
            self.infoButton.isSelected = true
            self.infoView.isHidden = false
            
        } else if button == requestButton {
            self.requestButton.isSelected = true
            self.requestView.isHidden = false
            
        } else if button == responseButton {
            self.responseButton.isSelected = true
            self.responseView.isHidden = false
            
        }
    }
    
    func responseBodyButtonPressed()
    {
        bodyButtonPressed().bodyType = NFXBodyType.response
    }
    
    func requestBodyButtonPressed()
    {
        bodyButtonPressed().bodyType = NFXBodyType.request
    }
    
    func bodyButtonPressed() -> NFXGenericBodyDetailsController {
        
        var bodyDetailsController: NFXGenericBodyDetailsController
        
        if self.selectedModel.shortType as String == HTTPModelShortType.IMAGE.rawValue {
            bodyDetailsController = NFXImageBodyDetailsController()
        } else {
            bodyDetailsController = NFXRawBodyDetailsController()
        }
        bodyDetailsController.selectedModel(self.selectedModel)
        self.navigationController?.pushViewController(bodyDetailsController, animated: true)
        return bodyDetailsController
    }
    
    func sendMailWithBodies(_ bodies: Bool)
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
                if let requestFileData = try? Data(contentsOf: URL(fileURLWithPath: requestFilePath as String)) {
                    mailComposer.addAttachmentData(requestFileData, mimeType: "text/plain", fileName: "request-body")
                }
                
                let responseFilePath = self.selectedModel.getResponseBodyFilepath()
                if let responseFileData = try? Data(contentsOf: URL(fileURLWithPath: responseFilePath as String)) {
                    mailComposer.addAttachmentData(responseFileData, mimeType: "text/plain", fileName: "response-body")
                }
            }

            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}

#endif
