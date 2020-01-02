//
//  customCell.swift
//  sqlite
//
//  Created by sachin shinde on 30/12/19.
//  Copyright © 2019 sachin shinde. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {

    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblSurname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
