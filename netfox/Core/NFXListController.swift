//
//  NFXListController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation


class NFXListController: NFXGenericController {

    // MARK: - Public Properties
    
    private(set) var tableData = [NFXHTTPModel]() {
        didSet {
            reloadData()
        }
    }
    
    var filter: String? = nil {
        didSet {
            filterModels()
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var dataSubscription = Subscription<[NFXHTTPModel]> { [weak self] in self?.allModels = $0 }
    
    private var allModels = [NFXHTTPModel]() {
        didSet {
            filterModels()
        }
    }
    
    // MARK: - Overloads
    
    deinit {
        dataSubscription.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NFXHTTPModelManager.shared.publisher.subscribe(dataSubscription)
        populate(with: NFXHTTPModelManager.shared.filteredModels)
    }
    
    // MARK: - Public Methods
    
    func populate(with models: [NFXHTTPModel]) {
        allModels = models
    }

    // MARK: - Private Methods
    
    private func filterModels() {
        guard let filter = filter, filter.isEmpty == false else {
            tableData = allModels
            return
        }
        
        tableData = allModels.filter {
            $0.requestURL?.range(of: filter, options: [.caseInsensitive, .diacriticInsensitive]) != nil ||
            $0.requestMethod?.range(of: filter, options: [.caseInsensitive, .diacriticInsensitive]) != nil ||
            $0.responseType?.range(of: filter, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }
    }
    
}
