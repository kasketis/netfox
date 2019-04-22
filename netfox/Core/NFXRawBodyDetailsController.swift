//
//  NFXRawBodyDetailsController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)

import Foundation
import UIKit

class NFXRawBodyDetailsController: NFXGenericBodyDetailsController
{
    var bodyView: UITextView = UITextView()
    private var copyAlert: UIAlertController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Body details"
        
        self.bodyView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.bodyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.bodyView.backgroundColor = UIColor.clear
        self.bodyView.textColor = UIColor.NFXGray44Color()
		self.bodyView.textAlignment = .left
        self.bodyView.isEditable = false
        self.bodyView.isSelectable = false
        self.bodyView.font = UIFont.NFXFont(size: 13)

        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(NFXRawBodyDetailsController.copyLabel))
        self.bodyView.addGestureRecognizer(lpgr)
        
        switch bodyType {
            case .request:
                self.bodyView.text = self.selectedModel.getRequestBody() as String
            default:
                self.bodyView.text = self.selectedModel.getResponseBody() as String
        }
        
        self.view.addSubview(self.bodyView)
    }

    @objc fileprivate func copyLabel(lpgr: UILongPressGestureRecognizer) {
        guard let text = (lpgr.view as? UITextView)?.text,
              copyAlert == nil else { return }

        UIPasteboard.general.string = text

        let alert = UIAlertController(title: "Text Copied!", message: nil, preferredStyle: .alert)
        copyAlert = alert

        self.present(alert, animated: true) { [weak self] in
            guard let `self` = self else { return }

            Timer.scheduledTimer(timeInterval: 0.45,
                                 target: self,
                                 selector: #selector(NFXRawBodyDetailsController.dismissCopyAlert),
                                 userInfo: nil,
                                 repeats: false)
        }
    }

    @objc fileprivate func dismissCopyAlert() {
        copyAlert?.dismiss(animated: true) { [weak self] in self?.copyAlert = nil }
    }
}

#endif
