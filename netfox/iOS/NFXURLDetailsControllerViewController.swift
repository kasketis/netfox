//
//  NFXURLDetailsController.swift
//  netfox_ios
//
//  Created by Tzatzo, Marsel on 05/06/2019.
//  Copyright © 2019 kasketis. All rights reserved.
//

#if os(iOS)

import Foundation
import UIKit

class NFXURLDetailsController: NFXDetailsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "URL Query Strings"
        self.view.layer.masksToBounds = true
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        let tableView: UITableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(tableView)
    }
    
}

extension NFXURLDetailsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        if let queryItem = self.selectedModel.requestURLQueryItems?[indexPath.row] {
            cell.textLabel?.text = queryItem.name
            cell.detailTextLabel?.text = queryItem.value
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
