//
//  ShopTableViewCell.swift
//  EduardoWashington
//
//  Created by Eduardo Wallace on 30/09/17.
//  Copyright © 2017 Eduardo Wallace. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfProduct: UILabel!
    @IBOutlet weak var tfState: UILabel!
    @IBOutlet weak var tfAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
