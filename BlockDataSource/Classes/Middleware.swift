//
//  Middleware.swift
//  Pods
//
//  Created by Adam Cumiskey on 2/6/17.
//
//

import Foundation


public protocol MiddlewareProtocol {
    var apply: (UIView) -> Void { get }
}

public struct ListMiddleware: MiddlewareProtocol {
    public var apply: (UIView) -> Void
    public init<Cell: UITableViewCell>(apply: @escaping (Cell) -> Void) {
        self.apply = { cell in
            if let cell = cell as? Cell {
                apply(cell)
            }
        }
    }
}

public struct GridMiddleware: MiddlewareProtocol {
    public var apply: (UIView) -> Void
    public init<Cell: UICollectionViewCell>(apply: @escaping (Cell) -> Void) {
        self.apply = { cell in
            if let cell = cell as? Cell {
                apply(cell)
            }
        }
    }
}
