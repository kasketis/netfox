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

    private var copyAlert: UIAlertController?

    var infoView: UIScrollView = UIScrollView()
    var requestView: UIScrollView = UIScrollView()
    var responseView: UIScrollView = UIScrollView()

    private lazy var headerButtons: [UIButton] = {
        return [self.infoButton, self.requestButton, self.responseButton]
    }()

    private lazy var infoViews: [UIScrollView] = {
        return [self.infoView, self.requestView, self.responseView]
    }()

    internal var sharedContent: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Details"
        self.view.layer.masksToBounds = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(NFXDetailsController_iOS.actionButtonPressed(_:)))

        // Header buttons
        self.infoButton = createHeaderButton("Info", x: 0, selector: #selector(NFXDetailsController_iOS.infoButtonPressed))
        self.requestButton = createHeaderButton("Request", x: self.infoButton.frame.maxX, selector: #selector(NFXDetailsController_iOS.requestButtonPressed))
        self.responseButton = createHeaderButton("Response", x: self.requestButton.frame.maxX, selector: #selector(NFXDetailsController_iOS.responseButtonPressed))
        self.headerButtons.forEach { self.view.addSubview($0) }

        // Info views
        self.infoView = createDetailsView(getInfoStringFromObject(self.selectedModel), forView: .info)
        self.requestView = createDetailsView(getRequestStringFromObject(self.selectedModel), forView: .request)
        self.responseView = createDetailsView(getResponseStringFromObject(self.selectedModel), forView: .response)
        self.infoViews.forEach { self.view.addSubview($0) }

        // Swipe gestures
        let lswgr = UISwipeGestureRecognizer(target: self, action: #selector(NFXDetailsController_iOS.handleSwipe(_:)))
        lswgr.direction = .left
        self.view.addGestureRecognizer(lswgr)

        let rswgr = UISwipeGestureRecognizer(target: self, action: #selector(NFXDetailsController_iOS.handleSwipe(_:)))
        rswgr.direction = .right
        self.view.addGestureRecognizer(rswgr)

        infoButtonPressed()
    }
    
    func createHeaderButton(_ title: String, x: CGFloat, selector: Selector) -> UIButton
    {
        var tempButton: UIButton
        tempButton = UIButton()
        tempButton.frame = CGRect(x: x, y: 0, width: self.view.frame.width / 3, height: 44)
        tempButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        tempButton.backgroundColor = UIColor.NFXDarkStarkWhiteColor()
        tempButton.setTitle(title, for: .init())
        tempButton.setTitleColor(UIColor.init(netHex: 0x6d6d6d), for: .init())
        tempButton.setTitleColor(UIColor.init(netHex: 0xf3f3f4), for: .selected)
        tempButton.titleLabel?.font = UIFont.NFXFont(size: 15)
        tempButton.addTarget(self, action: selector, for: .touchUpInside)
        return tempButton
    }

    @objc fileprivate func copyLabel(lpgr: UILongPressGestureRecognizer) {
        guard let text = (lpgr.view as? UILabel)?.text,
              copyAlert == nil else { return }

        UIPasteboard.general.string = text

        let alert = UIAlertController(title: "Text Copied!", message: nil, preferredStyle: .alert)
        copyAlert = alert

        self.present(alert, animated: true) { [weak self] in
            guard let `self` = self else { return }

            Timer.scheduledTimer(timeInterval: 0.45,
                                 target: self,
                                 selector: #selector(NFXDetailsController_iOS.dismissCopyAlert),
                                 userInfo: nil,
                                 repeats: false)
        }
    }

    @objc fileprivate func dismissCopyAlert() {
        copyAlert?.dismiss(animated: true) { [weak self] in self?.copyAlert = nil }
    }
    
    func createDetailsView(_ content: NSAttributedString, forView: EDetailsView) -> UIScrollView
    {
        var scrollView: UIScrollView
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height - 44)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.autoresizesSubviews = true
        scrollView.backgroundColor = UIColor.clear
        
        var textView: UITextView
        textView = UITextView()
        textView.frame = CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20);
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.NFXFont(size: 13)
        textView.textColor = UIColor.NFXGray44Color()
        textView.isEditable = false
        textView.attributedText = content
        textView.sizeToFit()
        textView.isUserInteractionEnabled = true
        textView.delegate = self
        scrollView.addSubview(textView)

        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(NFXDetailsController_iOS.copyLabel))
        textView.addGestureRecognizer(lpgr)
        
        var moreButton: UIButton
        moreButton = UIButton.init(frame: CGRect(x: 20, y: textView.frame.maxY + 10, width: scrollView.frame.width - 40, height: 40))
        moreButton.backgroundColor = UIColor.NFXGray44Color()
        
        if ((forView == EDetailsView.request) && (self.selectedModel.requestBodyLength > 1024)) {
            moreButton.setTitle("Show request body", for: .init())
            moreButton.addTarget(self, action: #selector(NFXDetailsController_iOS.requestBodyButtonPressed), for: .touchUpInside)
            scrollView.addSubview(moreButton)
            scrollView.contentSize = CGSize(width: textView.frame.width, height: moreButton.frame.maxY + 16)

        } else if ((forView == EDetailsView.response) && (self.selectedModel.responseBodyLength > 1024)) {
            moreButton.setTitle("Show response body", for: .init())
            moreButton.addTarget(self, action: #selector(NFXDetailsController_iOS.responseBodyButtonPressed), for: .touchUpInside)
            scrollView.addSubview(moreButton)
            scrollView.contentSize = CGSize(width: textView.frame.width, height: moreButton.frame.maxY + 16)
            
        } else {
            scrollView.contentSize = CGSize(width: textView.frame.width, height: textView.frame.maxY + 16)
        }
        
        return scrollView
    }
    
    @objc func actionButtonPressed(_ sender: UIBarButtonItem)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheetController.addAction(cancelAction)
        
        let simpleLog: UIAlertAction = UIAlertAction(title: "Simple log", style: .default) { [unowned self] action -> Void in
            self.shareLog(full: false, sender: sender)
        }
        actionSheetController.addAction(simpleLog)
        
        let fullLogAction: UIAlertAction = UIAlertAction(title: "Full log", style: .default) { [unowned self] action -> Void in
            self.shareLog(full: true, sender: sender)
        }
        actionSheetController.addAction(fullLogAction)
        
        if let reqCurl  = self.selectedModel.requestCurl {
            let curlAction: UIAlertAction = UIAlertAction(title: "Export request as curl", style: .default) { [unowned self] action -> Void in
                let activityViewController = UIActivityViewController(activityItems: [reqCurl], applicationActivities: nil)
                activityViewController.popoverPresentationController?.barButtonItem = sender
                self.present(activityViewController, animated: true, completion: nil)
            }
            actionSheetController.addAction(curlAction)
        }

        
        actionSheetController.view.tintColor = UIColor.NFXOrangeColor()
        actionSheetController.popoverPresentationController?.barButtonItem = sender

        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc func infoButtonPressed()
    {
        buttonPressed(self.infoButton)
    }
    
    @objc func requestButtonPressed()
    {
        buttonPressed(self.requestButton)
    }
    
    @objc func responseButtonPressed()
    {
        buttonPressed(self.responseButton)
    }

    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard let currentButtonIdx = headerButtons.firstIndex(where: { $0.isSelected }) else { return }
        let numButtons = headerButtons.count

        switch gesture.direction {
            case .left:
                let nextIdx = currentButtonIdx + 1
                buttonPressed(headerButtons[nextIdx > numButtons - 1 ? 0 : nextIdx])
            case .right:
                let previousIdx = currentButtonIdx - 1
                buttonPressed(headerButtons[previousIdx < 0 ? numButtons - 1 : previousIdx])
            default: break
        }
    }
    
    func buttonPressed(_ sender: UIButton)
    {
        guard let selectedButtonIdx = self.headerButtons.firstIndex(of: sender) else { return }
        let infoViews = [self.infoView, self.requestView, self.responseView]

        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseInOut,
                       animations: { [unowned self] in
                            self.headerButtons.indices.forEach {
                                let button = self.headerButtons[$0]
                                let view = infoViews[$0]

                                button.isSelected = button == sender
                                view.frame = CGRect(x: CGFloat(-selectedButtonIdx + $0) * view.frame.size.width,
                                                    y: view.frame.origin.y,
                                                    width: view.frame.size.width,
                                                    height: view.frame.size.height)
                            }
                       },
                       completion: nil)
    }
    
    @objc func responseBodyButtonPressed()
    {
        bodyButtonPressed().bodyType = NFXBodyType.response
    }
    
    @objc func requestBodyButtonPressed()
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
    
    func shareLog(full: Bool, sender: UIBarButtonItem)
    {
        var tempString = String()

        tempString += "** INFO **\n"
        tempString += "\(getInfoStringFromObject(self.selectedModel).string)\n\n"

        tempString += "** REQUEST **\n"
        tempString += "\(getRequestStringFromObject(self.selectedModel).string)\n\n"

        tempString += "** RESPONSE **\n"
        tempString += "\(getResponseStringFromObject(self.selectedModel).string)\n\n"

        tempString += "logged via netfox - [https://github.com/kasketis/netfox]\n"

        if full {
            let requestFilePath = self.selectedModel.getRequestBodyFilepath()
            if let requestFileData = try? String(contentsOf: URL(fileURLWithPath: requestFilePath as String), encoding: .utf8) {
                tempString += requestFileData
            }

            let responseFilePath = self.selectedModel.getResponseBodyFilepath()
            if let responseFileData = try? String(contentsOf: URL(fileURLWithPath: responseFilePath as String), encoding: .utf8) {
                tempString += responseFileData
            }
        }
        displayShareSheet(shareContent: tempString, sender: sender)
    }

    func displayShareSheet(shareContent: String, sender: UIBarButtonItem) {
        self.sharedContent = shareContent
        let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        present(activityViewController, animated: true, completion: nil)
    }
}

extension NFXDetailsController_iOS: UIActivityItemSource {
    public typealias UIActivityType = UIActivity.ActivityType
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "placeholder"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType?) -> Any? {
        return sharedContent
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return "netfox log - \(self.selectedModel.requestURL!)"
    }
}

extension NFXDetailsController_iOS: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let decodedURL = URL.absoluteString.removingPercentEncoding
        switch decodedURL {
        case "[URL]":
            guard let queryItems = self.selectedModel.requestURLQueryItems, queryItems.count > 0 else {
                return false
            }
            let urlDetailsController = NFXURLDetailsController()
            urlDetailsController.selectedModel = self.selectedModel
            self.navigationController?.pushViewController(urlDetailsController, animated: true)
            return true
        default:
            return false
        }
        
    }
    
}

#endif
