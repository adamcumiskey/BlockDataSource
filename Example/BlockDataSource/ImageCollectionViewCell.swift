//
//  ImageCollectionViewCell.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 11/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
    }

}
