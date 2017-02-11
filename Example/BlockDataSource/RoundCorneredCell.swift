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
    
    public var position: Postion = .middle {
        didSet { layoutSubviews() }
    }
    
    private weak var separator: UIView?
    public var customSeparatorColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2044084821) {
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
    
    private var _cornerRadius: CGFloat? = nil
    public var cornerRadius: CGFloat {
        get {
            return _cornerRadius ?? contentView.frame.height/2.0
        }
        set(newRadius){
            _cornerRadius = newRadius
            setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = _backgroundColor
        
        // Apply Corners
        var corners: UIRectCorner?
        switch position {
        case .top:
            corners = [.topLeft, .topRight]
            if let separatorColor = customSeparatorColor {
                drawCustomSeparator(with: separatorColor)
            }
        case .middle:
            if let separatorColor = customSeparatorColor {
                drawCustomSeparator(with: separatorColor)
            }
        case .bottom:
            corners = [.bottomLeft, .bottomRight]
            separator?.removeFromSuperview()
        }
        
        if let corners = corners {
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
    
    func drawCustomSeparator(with color: UIColor) {
        if let separator = separator {
            separator.backgroundColor = color
        } else {
            let view = UIView(
                frame: CGRect(
                    x: separatorInset.left,
                    y: contentView.bounds.height-0.5,
                    width: contentView.bounds.width - (separatorInset.left + separatorInset.right),
                    height: 0.5
                )
            )
            view.backgroundColor = color
            separator = view
            contentView.addSubview(view)
        }
    }
}
