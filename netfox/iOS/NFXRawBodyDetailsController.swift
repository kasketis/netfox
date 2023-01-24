//
//  NFXRawBodyDetailsController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(iOS)

import Foundation
import UIKit

class NFXRawBodyDetailsController: NFXGenericBodyDetailsController {
    var bodyView: UITextView = UITextView()
    private var copyAlert: UIAlertController?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.barTintColor = UIColor.NFXOrangeColor()
        searchController.searchBar.tintColor = UIColor.NFXOrangeColor()
        searchController.searchBar.searchBarStyle = .minimal
        searchController.view.backgroundColor = UIColor.clear
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewFrame = view.frame
        
        title = "Body details"
        
        configureNavigationBar()

        bodyView.frame = CGRect(x: 0, y: 0, width: viewFrame.width, height: viewFrame.height)
        bodyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bodyView.backgroundColor = UIColor.clear
        bodyView.textColor = UIColor.NFXGray44Color()
		bodyView.textAlignment = .left
        bodyView.isEditable = false
        bodyView.isSelectable = false
        bodyView.font = UIFont.NFXFont(size: 13)

        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(NFXRawBodyDetailsController.copyLabel))
        bodyView.addGestureRecognizer(lpgr)
        
        switch bodyType {
        case .request:
            bodyView.attributedText = formatNFXString(selectedModel.getRequestBody())
        default:
            bodyView.attributedText = formatNFXString(selectedModel.getResponseBody())
        }
        
        view.addSubview(bodyView)
    }
    
    private func configureNavigationBar() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            definesPresentationContext = true
        } else {
            let searchView = UIView()
            searchView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 60, height: 0)
            searchView.autoresizingMask = [.flexibleWidth]
            searchView.autoresizesSubviews = true
            searchView.backgroundColor = UIColor.clear
            searchView.addSubview(searchController.searchBar)
            searchController.searchBar.sizeToFit()
            searchView.frame = searchController.searchBar.frame

            navigationItem.titleView = searchView
        }
    }

    @objc fileprivate func copyLabel(lpgr: UILongPressGestureRecognizer) {
        guard let text = (lpgr.view as? UITextView)?.text,
              copyAlert == nil else { return }

        UIPasteboard.general.string = text

        let alert = UIAlertController(title: "Text Copied!", message: nil, preferredStyle: .alert)
        copyAlert = alert

        present(alert, animated: true) { [weak self] in
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

// MARK: - UISearchResultsUpdating
extension NFXRawBodyDetailsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        
        switch bodyType {
        case .request:
            bodyView.attributedText = formatNFXString(selectedModel.getRequestBody(), searchString: searchString)
        default:
            bodyView.attributedText = formatNFXString(selectedModel.getResponseBody(), searchString: searchString)
        }
    }
}

// MARK: - UISearchControllerDelegate
extension NFXRawBodyDetailsController: UISearchControllerDelegate {
}

#endif
