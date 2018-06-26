//
//  ImageCollectionViewCell.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
