//
//  NFXURLDetailsController.swift
//  netfox_ios
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 05/06/2019.
//  Copyright © 2019 kasketis. All rights reserved.
//

#if os(iOS)

import Foundation
import UIKit

class NFXURLDetailsController: NFXDetailsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "URL Details"
        self.view.layer.masksToBounds = true
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        let tableView: UITableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.dataSource = self
        tableView.register(UINib(nibName: NFXURLQueryStringTableViewCell.cellName,
                                 bundle: Bundle(for: self.classForCoder)),
                           forCellReuseIdentifier: NFXURLQueryStringTableViewCell.cellName)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(tableView)
    }
}

extension NFXURLDetailsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFXURLQueryStringTableViewCell.cellName,
                                                       for: indexPath) as? NFXURLQueryStringTableViewCell else
        {
            return UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        if let queryItem = self.selectedModel.requestURLQueryItems?[indexPath.row] {
            cell.titleLabel.text = queryItem.name
            cell.valueLabel.text = queryItem.value
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let queryItems = self.selectedModel.requestURLQueryItems else {
            return 0
        }
        return queryItems.count
    }
    
}


#endif
