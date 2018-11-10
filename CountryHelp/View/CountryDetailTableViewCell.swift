//
//  countryDetailTableViewCell.swift
//  CountryHelp
//
//  Created by Denis Zubkov on 26/06/2018.
//  Copyright © 2018 Dennis Zubkoff. All rights reserved.
//

import UIKit

class CountryDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var propertyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
