//
//  Middleware.swift
//  Pods
//
//  Created by Adam Cumiskey on 2/6/17.
//
//

import Foundation


public struct Middleware {
    var cellClass: UITableViewCell.Type
    var apply: (UITableViewCell) -> Void
    public init<Cell: UITableViewCell>(apply: @escaping (Cell) -> Void) {
        self.cellClass = Cell.self
        self.apply = { cell in
            apply(cell as! Cell)
        }
    }
}
