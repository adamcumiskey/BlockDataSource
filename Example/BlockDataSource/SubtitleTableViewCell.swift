//
//  MenuTableViewCell.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/9/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
