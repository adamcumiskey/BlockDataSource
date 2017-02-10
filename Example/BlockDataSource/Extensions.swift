//
//  Extentions.swift
//  Pods
//
//  Created by Adam Cumiskey on 12/15/16.
//
//

import Foundation
import UIKit


extension Array {
    mutating func moveObjectAtIndex(_ index: Int, toIndex: Int) {
        let element = self[index]
        remove(at: index)
        insert(element, at: toIndex)
    }
}


extension UIView {
    func outline(color: UIColor = .green, borderWidth: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
}
