//
//  HOFTableViewCell.swift
//  ste
//
//  Created by Zdeněk Skulínek on 23.01.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import UIKit

class HOFTableViewCell: UITableViewCell {
    
    @IBOutlet var date:UILabel?
    @IBOutlet var name:UILabel?
    @IBOutlet var level:UILabel?
    @IBOutlet var points:UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
