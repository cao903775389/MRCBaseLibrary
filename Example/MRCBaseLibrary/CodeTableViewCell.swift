//
//  CodeTableViewCell.swift
//  MRCBaseLibrary
//
//  Created by 逢阳曹 on 2017/6/7.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class CodeTableViewCell: UITableViewCell, NICell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func shouldUpdate(with object: Any!) -> Bool {
        
        self.textLabel?.text = "代码cell"
        
        return true
    }

}
