//
//  CategoryFilterCell.swift
//  Yelp
//
//  Created by Liqiang Ye on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

//#1. declare the delegate protocol
@objc protocol CategoryCellDelegate {
    //define delegate functions
    func categorySwitchChanged(categoryCell: CategoryFilterCell, switchIsOn: Bool)
}

class CategoryFilterCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!
    
    //#2. declare delegate variable
    weak var delegate: CategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categorySwitch.addTarget(self, action: #selector(onCategorySwitchChanged(categorySwitch:)), for: .valueChanged)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func onCategorySwitchChanged(categorySwitch: UISwitch!) {
        //#3. invoke delegate function
        delegate?.categorySwitchChanged(categoryCell: self, switchIsOn: categorySwitch.isOn)
    }

}
