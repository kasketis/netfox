//
//  NFXURLQueryStringTableViewCell.swift
//  netfox_ios
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 05/06/2019.
//  Copyright © 2019 kasketis. All rights reserved.
//

import UIKit

class NFXURLQueryStringTableViewCell: UITableViewCell {
    
    static let cellName = "NFXURLQueryStringTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
