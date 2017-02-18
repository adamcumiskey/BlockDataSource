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
        case single
    }
    
    public var position: Postion = .middle {
        didSet { layoutSubviews() }
    }
    
    private weak var separator: UIView?
    public var customSeparatorColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2044084821) {
        didSet { layoutSubviews() }
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
    
    private static let noCornerRadiusValue: CGFloat = 0.0001
    private var maskLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        maskLayer = CAShapeLayer(layer: UIBezierPath(roundedRect: bounds, cornerRadius: RoundCorneredCell.noCornerRadiusValue))
        layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        maskLayer.frame = bounds
        self.updateStyle(animated: true)
    }
    
    private func updateStyle(animated: Bool) {
        // Apply Corners
        var corners: UIRectCorner = []
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
        case .single:
            corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
            separator?.removeFromSuperview()
        }
        
        // Don't render corners while editing
        let radius = isEditing ? RoundCorneredCell.noCornerRadiusValue : cornerRadius
        layer.masksToBounds = !isEditing

        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        if animated {
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = maskLayer.path
            animation.toValue = path.cgPath
            animation.duration = 0.23
            maskLayer.add(animation, forKey: "maskPath")
        }
        CATransaction.begin()
        CATransaction.disableActions()
        maskLayer.path = path.cgPath
        CATransaction.commit()
    }
    
    func drawCustomSeparator(with color: UIColor) {
        let frame = CGRect(
            x: separatorInset.left,
            y: contentView.bounds.height-0.5,
            width: contentView.bounds.width - (separatorInset.left + separatorInset.right),
            height: 0.5
        )
        if let separator = separator {
            separator.backgroundColor = color
            separator.frame = frame
        } else {
            let view = UIView(frame: frame)
            view.backgroundColor = color
            separator = view
            contentView.addSubview(view)
        }
    }
}
