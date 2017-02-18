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
    public var apply: (UITableViewCell, IndexPath, [List.Section]) -> Void // will the sections pass by value?
    public init<Cell: UITableViewCell>(apply: @escaping (Cell, IndexPath, [List.Section]) -> Void) {
        self.cellClass = Cell.self
        self.apply = { cell, indexPath, structure in
            if let cell = cell as? Cell {
                apply(cell, indexPath, structure)
            }
        }
    }
}
