//
//  InformationHeaderFooterView.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class InformationHeaderFooterView: UITableViewHeaderFooterView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addConstraints(
            [
                NSLayoutConstraint(
                    item: contentView,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1.0,
                    constant: 75
                ),
                NSLayoutConstraint(
                    item: titleLabel,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: contentView,
                    attribute: .top,
                    multiplier: 1.0,
                    constant: 16
                ),
                NSLayoutConstraint(
                    item: titleLabel,
                    attribute: .left,
                    relatedBy: .equal,
                    toItem: contentView,
                    attribute: .left,
                    multiplier: 1.0,
                    constant: 16
                ),
                NSLayoutConstraint(
                    item: titleLabel,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: contentView,
                    attribute: .bottom,
                    multiplier: 1.0,
                    constant: -16
                ),
                NSLayoutConstraint(
                    item: titleLabel,
                    attribute: .right,
                    relatedBy: .equal,
                    toItem: contentView,
                    attribute: .right,
                    multiplier: 1.0,
                    constant: 16
                )
            ]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
