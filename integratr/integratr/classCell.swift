//
//  classCell.swift
//  integratr
//
//  Created by Adam Bujak on 2018-07-11.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import UIKit

class classCell: UITableViewCell {

    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
