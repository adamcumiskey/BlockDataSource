//
//  Type.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import Foundation


// MARK: - TypeSet
/// A type which holds the data types for a data source
public protocol DataSourceTypeSet {
    associatedtype Item: ItemProtocol
    associatedtype Decoration: ReusableProtocol
    associatedtype Middleware: MiddlewareProtocol
    init()
}

public struct List: DataSourceTypeSet {
    public typealias Item = ListItem
    public typealias Decoration = ListSectionDecoration
    public typealias Middleware = ListMiddleware
    public init() {}
}

public struct Grid: DataSourceTypeSet {
    public typealias Item = GridItem
    public typealias Decoration = GridSectionDecoration
    public typealias Middleware = GridMiddleware
    public init() {}
}

