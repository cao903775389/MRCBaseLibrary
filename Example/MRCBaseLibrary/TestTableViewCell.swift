//
//  TestTableViewCell.swift
//  MRCBaseLibrary
//
//  Created by 逢阳曹 on 2017/6/7.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell, NICell {

    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var trialTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func shouldUpdate(with object: Any!) -> Bool {
        
        guard let object = object as? TrialListItemModel else { return false }
                
        coverImageView.setImageWith(URL(string: object.iu), placeholder: UIImage(named: "750x480"), options: .setImageWithFadeAnimation)
        trialTitle.text = object.tt
        return true
    }
}
