//
//  Middleware.swift
//  Pods
//
//  Created by Adam Cumiskey on 2/6/17.
//
//

import Foundation


public protocol Middleware {
    var apply: (UIView) -> Void { get }
}

public struct ListMiddleware: Middleware {
    public var apply: (UIView) -> Void
    public init<Cell: UITableViewCell>(apply: @escaping (Cell) -> Void) {
        self.apply = { cell in
            if let cell = cell as? Cell {
                apply(cell)
            }
        }
    }
}

public struct GridMiddleware: Middleware {
    public var apply: (UIView) -> Void
    public init<Cell: UICollectionViewCell>(apply: @escaping (Cell) -> Void) {
        self.apply = { cell in
            if let cell = cell as? Cell {
                apply(cell)
            }
        }
    }
}
