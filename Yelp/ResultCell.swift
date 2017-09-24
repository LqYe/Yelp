//
//  ResultCell.swift
//  Yelp
//
//  Created by Liqiang Ye on 9/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var resultThumbImageView: UIImageView!
    @IBOutlet weak var resultNameLabelView: UILabel!
    @IBOutlet weak var resultDistanceLabelView: UILabel!
    @IBOutlet weak var resultRatingImageView: UIImageView!
    @IBOutlet weak var resultCategoryLabelView: UILabel!
    @IBOutlet weak var resultReviewsCountLabelView: UILabel!
    @IBOutlet weak var resultAddressLabelView: UILabel!
    
    //property observer
    var business: Business! {
        didSet {
            resultThumbImageView.setImageWith(business.imageURL!)
            resultNameLabelView.text = business.name
            resultDistanceLabelView.text = business.distance
            resultRatingImageView.setImageWith(business.ratingImageURL!)
            resultCategoryLabelView.text = business.categories
            resultReviewsCountLabelView.text = "\(business.reviewCount ?? 0) Reviews"
            resultAddressLabelView.text = business.address
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resultThumbImageView.layer.cornerRadius = 3
        resultRatingImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
