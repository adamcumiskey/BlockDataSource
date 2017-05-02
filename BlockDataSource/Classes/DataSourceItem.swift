//
//  DataSourceItemBase.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import Foundation

// MARK: - DataSourceDataType
/// A type which holds the data types for a data source
public protocol DataSourceDataType {
    associatedtype Container: UIView
    associatedtype Item: DataSourceItemProtocol
    associatedtype Decoration: DataSourceReusableProtocol
    associatedtype Middleware: MiddlewareProtocol
}

public struct List: DataSourceDataType {
    public typealias Container = UITableView
    public typealias Item = ListItem
    public typealias Decoration = ListSectionDecoration
    public typealias Middleware = ListMiddleware
}

public struct Grid: DataSourceDataType {
    public typealias Container = UICollectionView
    public typealias Item = GridItem
    public typealias Decoration = GridSectionDecoration
    public typealias Middleware = GridMiddleware
}

// MARK: - DataSourceReusableProtocol
/// Any data type that can configure a view
public protocol DataSourceReusableProtocol {
    var configure: ConfigureBlock { get }
    var viewClass: UIView.Type { get }
    var reuseIdentifier: String { get }
}

public class DataSourceReusable {
    public var configure: ConfigureBlock
    public var viewClass: UIView.Type

    public var customReuseIdentifier: String?
    public var reuseIdentifier: String {
        if let customReuseIdentifier = customReuseIdentifier {
            return customReuseIdentifier
        } else {
            return String(describing: viewClass)
        }
    }

    public init<T: UIView>(customReuseIdentifier: String? = nil, configure: @escaping (T) -> Void) {
        self.configure = { view in
            configure(view as! T)
        }
        self.viewClass = T.self
    }
}


// MARK: - DataSourceItemProtocol
/// A DataSourceReusable that can be selected, deleted, and reordered.
public protocol DataSourceItemProtocol: DataSourceReusableProtocol {
    // The block that executes when the item is tapped
    var onSelect: IndexPathBlock? { get set }
    // The block that executes when the item is deleted
    var onDelete: IndexPathBlock? { get set }
    // Lets the dataSource know that this item can be reordered
    var reorderable: Bool { get set }
}

/// Helper abstract base class which defines the variables that will allow subclasses easy
/// protocol conformance to DataSourceItemProtocol.
/// NOTE: This class does not conform to DataSourceItemProtocol and should not be directly instantiated.
public class DataSourceItemBase: DataSourceReusable {
    public var onSelect: IndexPathBlock?
    public var onDelete: IndexPathBlock?
    public var reorderable: Bool = false

    /**
     Initialize a item

     - parameters:
     - configure: The configuration block.
     - onSelect: The closure to execute when the item is tapped
     - onDelete: The closure to execute when the item is deleted
     - reorderable: Flag to indicate if this item can be reordered
     - customReuseIdentifier: Set to override the default reuseIdentifier. Default is nil.
     */
    public init<T: UIView>(configure: @escaping (T) -> Void, onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = false, customReuseIdentifier: String? = nil) where T : UIView {
        super.init(customReuseIdentifier: customReuseIdentifier, configure: configure)
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.reorderable = reorderable
    }
}

// MARK: - Data Type Implementations

/// UITableViewCell
public class ListItem: DataSourceItemBase, DataSourceItemProtocol {
    public override init<Cell: UITableViewCell>(configure: @escaping (Cell) -> Void, onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = true, customReuseIdentifier: String? = nil) {
        super.init(configure: configure, onSelect: onSelect, onDelete: onDelete, reorderable: reorderable, customReuseIdentifier: customReuseIdentifier)
    }
}

/// UIView for UITableView headers/footers
public class ListSectionDecoration: DataSourceReusable, DataSourceReusableProtocol { }

/// UICollectionViewCell
public class GridItem: DataSourceItemBase, DataSourceItemProtocol {
    public override init<Cell: UICollectionViewCell>(configure: @escaping (Cell) -> Void, onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = true, customReuseIdentifier: String? = nil) {
        super.init(configure: configure, onSelect: onSelect, onDelete: onDelete, reorderable: reorderable, customReuseIdentifier: customReuseIdentifier)
    }
}

/// UICollectionReusableView
public class GridSectionDecoration: DataSourceReusable, DataSourceReusableProtocol {
    public override init<View: UICollectionReusableView>(customReuseIdentifier: String? = nil, configure: @escaping (View) -> Void) {
        super.init(customReuseIdentifier: customReuseIdentifier, configure: configure)
    }
}
