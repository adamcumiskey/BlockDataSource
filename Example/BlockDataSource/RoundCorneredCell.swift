//
//  RoundCorneredCell.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 2/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import QuartzCore


class RoundCorneredCell: UITableViewCell {
    enum Postion {
        case top
        case middle
        case bottom
    }
    
    var xInset: CGFloat = 20.0
    var position: Postion = .middle {
        didSet { layoutSubviews() }
    }
    
    private var _backgroundColor: UIColor? = .white
    override var backgroundColor: UIColor? {
        get {
            return _backgroundColor
        }
        set(newColor) {
            super.backgroundColor = nil
            _backgroundColor = newColor
            setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .red
        contentView.outline()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = _backgroundColor
        
        let newFrame = contentView.bounds.insetBy(dx: xInset, dy: 0)
        contentView.frame = newFrame
        
        // Apply Corners
        var corners: UIRectCorner?
        switch position {
        case .top:
            corners = [.topLeft, .topRight]
        case .middle: break
        case .bottom:
            corners = [.bottomLeft, .bottomRight]
        }
        
        
        if let corners = corners {
            let cornerRadius = contentView.frame.height/2.0
            let path = UIBezierPath(
                roundedRect: contentView.bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            contentView.layer.mask = mask
        }
    }
}
