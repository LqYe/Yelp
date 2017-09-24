//
//  OfferingFilterCell.swift
//  Yelp
//
//  Created by Liqiang Ye on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class OfferFilterCell: UITableViewCell {

    var offerFilterSwitch: (Bool) -> Void  = { (isOn) -> Void in }
    
    @IBOutlet weak var offerSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
    @IBAction func onOfferingFilterSwitchChanged(_ sender: UISwitch) {
        
        offerFilterSwitch(sender.isOn)
    }
}
