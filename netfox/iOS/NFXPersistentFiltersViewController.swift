//
//  NFXPersistentFiltersViewController.swift
//  netfox_ios
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 05/06/2019.
//  Copyright © 2019 kasketis. All rights reserved.
//

#if os(iOS)

import UIKit

class NFXPersistentFiltersViewController: UIViewController {

    lazy var rightBarButtonItems: [UIBarButtonItem] = {
        [UIBarButtonItem(barButtonSystemItem: .edit,
                        target: self,
                        action: #selector(NFXPersistentFiltersViewController.editButtonPressed)),
         UIBarButtonItem(barButtonSystemItem: .add,
                        target: self,
                        action: #selector(NFXPersistentFiltersViewController.addButtonPressed))]
    }()
    
    lazy var editModeRightBarButtonItems: [UIBarButtonItem] = {
        [UIBarButtonItem(barButtonSystemItem: .cancel,
                        target: self,
                        action: #selector(NFXPersistentFiltersViewController.cancelPressed))]
    }()
    
    
    let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(tableView)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.frame = self.view.bounds
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.NFXClose(),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(NFXPersistentFiltersViewController.closeButtonPressed))
        
        self.navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    @objc func closeButtonPressed() {
        if let presenter = presentingViewController as? NFXListController_iOS {
            presenter.reloadTableViewData()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonPressed() {
        self.showAlert()
    }
    
    fileprivate func showAlert() {
        let alert = UIAlertController(title: "Enter a filter",
                                      message: "Your request urls will be filtered against all the hosts added. Condition operator is OR",
                                      preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            NFXHTTPModelManager.sharedInstance.hosts.append(text)
            self.tableView.reloadData()
        }
        alert.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            textField.placeholder = "Host"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension NFXPersistentFiltersViewController {
    
    @objc func editButtonPressed() {
        self.navigationItem.rightBarButtonItems = self.editModeRightBarButtonItems
        self.tableView.setEditing(true, animated: true)
    }
    
    @objc func cancelPressed() {
        self.navigationItem.rightBarButtonItems = self.rightBarButtonItems
        self.tableView.setEditing(false, animated: true)
    }
    
}

extension NFXPersistentFiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NFXHTTPModelManager.sharedInstance.hosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = NFXHTTPModelManager.sharedInstance.hosts[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            NFXHTTPModelManager.sharedInstance.hosts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension NFXPersistentFiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}


#endif
