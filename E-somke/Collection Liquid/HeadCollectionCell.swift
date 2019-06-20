//
//  HeadCollectionCell.swift
//  E-somke
//
//  Created by Piotr Żakieta on 20/06/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit

class HeadCollectionCell: UITableViewCell {

    @IBOutlet weak var headLabelCell: UILabel!
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var starsCell: UILabel!
    @IBOutlet weak var secondLabelCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
