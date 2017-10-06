//
//  SettingsTableViewCell.swift
//  EduardoWashington
//
//  Created by Eduardo Wallace on 06/10/2017.
//  Copyright © 2017 Eduardo Wallace. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var tfState: UILabel!
    @IBOutlet weak var tfIOF: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
