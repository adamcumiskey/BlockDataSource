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

public class MiddlewareBase {
    public var apply: (UIView) -> Void
    public init<View: UIView>(apply: @escaping (View) -> Void) {
        self.apply = { view in
            if let view = view as? View {
                apply(view)
            }
        }
    }
}

public class Middleware: MiddlewareBase, MiddlewareProtocol {
    public override init<View: UIView>(apply: @escaping (View) -> Void) {
        super.init(apply: apply)
    }
}

public class ListMiddleware: Middleware {
    public override init<View: UITableViewCell>(apply: @escaping (View) -> Void) {
        super.init(apply: apply)
    }
}

public class GridMiddleware: Middleware {
    public override init<View: UICollectionViewCell>(apply: @escaping (View) -> Void) {
        super.init(apply: apply)
    }
}
