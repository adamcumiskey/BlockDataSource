//
//  ImageReusableView.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 12/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit


class ImageReusableView: UICollectionReusableView {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFit
    }
}
