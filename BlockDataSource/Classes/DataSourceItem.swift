//
//  DataSourceItem.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import Foundation


// MARK: -
///
public protocol DataSourceConfigurable {
    var configure: ConfigureBlock { get }

    var viewClass: UIView.Type { get }

    var reuseIdentifier: String { get }
}


// MARK: -
///
public protocol DataSourceItem: DataSourceConfigurable {
    associatedtype HeaderType: DataSourceConfigurable
    associatedtype MiddlewareType: Middleware

    // The block that executes when the cell is tapped
    var onSelect: IndexPathBlock? { get set }

    // The block that executes when the cell is deleted
    var onDelete: IndexPathBlock? { get set }

    // Lets the dataSource know that this item can be reordered
    var reorderable: Bool { get set }
}


// MARK: -
///
public struct ListItem: DataSourceItem {
    public typealias HeaderType = ListHeader
    public typealias MiddlewareType = ListMiddleware

    // The block which configures the cell
    public var configure: ConfigureBlock

    // The block that executes when the cell is tapped
    public var onSelect: IndexPathBlock?

    // The block that executes when the cell is deleted
    public var onDelete: IndexPathBlock?

    // Lets the dataSource know that this item can be reordered
    public var reorderable: Bool = false

    public var viewClass: UIView.Type

    private var customReuseIdentifier: String?

    public var reuseIdentifier: String {
        if let customReuseIdentifier = customReuseIdentifier {
            return customReuseIdentifier
        } else {
            return String(describing: viewClass)
        }
    }

    /**
     Initialize a item

     - parameters:
     - configure: The cell configuration block.
     - onSelect: The closure to execute when the cell is tapped
     - onDelete: The closure to execute when the cell is deleted
     - reorderable: Flag to indicate if this cell can be reordered
     - customReuseIdentifier: Set to override the default reuseIdentifier. Default is nil.
     */
    public init<Cell: UITableViewCell>(configure: @escaping (Cell) -> Void, onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = true, customReuseIdentifier: String? = nil) {
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.reorderable = reorderable
        self.customReuseIdentifier = customReuseIdentifier

        self.viewClass = Cell.self
        self.configure = { cell in
            configure(cell as! Cell)
        }
    }

    // Convienence init for trailing closure syntax
    public init<Cell: UITableViewCell>(reorderable: Bool = true, configure: @escaping (Cell) -> Void) {
        self.init(
            configure: configure,
            onSelect: nil,
            onDelete: nil,
            reorderable: reorderable
        )
    }
}


// MARK: -
///
public struct GridItem: DataSourceItem {
    public typealias HeaderType = GridHeader
    public typealias MiddlewareType = GridMiddleware

    // The block which configures the cell
    public var configure: ConfigureBlock

    // The block that executes when the cell is tapped
    public var onSelect: IndexPathBlock?

    // The block that executes when the cell is deleted
    public var onDelete: IndexPathBlock?

    // Lets the dataSource know that this item can be reordered
    public var reorderable: Bool = false

    public var viewClass: UIView.Type

    private var customReuseIdentifier: String?

    public var reuseIdentifier: String {
        if let customReuseIdentifier = customReuseIdentifier {
            return customReuseIdentifier
        } else {
            return String(describing: viewClass)
        }
    }

    /**
     Initialize a item

     - parameters:
     - configure: The cell configuration block.
     - onSelect: The closure to execute when the cell is tapped
     - onDelete: The closure to execute when the cell is deleted
     - reorderable: Flag to indicate if this cell can be reordered
     - customReuseIdentifier: Set to override the default reuseIdentifier. Default is nil.
     */
    public init<Cell: UICollectionViewCell>(configure: @escaping (Cell) -> Void, onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = true, customReuseIdentifier: String? = nil) {
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.reorderable = reorderable
        self.customReuseIdentifier = customReuseIdentifier

        self.viewClass = Cell.self
        self.configure = { cell in
            configure(cell as! Cell)
        }
    }

    // Convienence init for trailing closure syntax
    public init<Cell: UICollectionViewCell>(reorderable: Bool = true, configure: @escaping (Cell) -> Void) {
        self.init(
            configure: configure,
            onSelect: nil,
            onDelete: nil,
            reorderable: reorderable
        )
    }
}

// MARK: - Header Footer
/// Data structure representing a header or footer for a grid section
public struct ListHeader: DataSourceConfigurable {

    /// Configuration block for this HeaderFooter
    public var configure: ConfigureBlock

    public var viewClass: UIView.Type

    private var customReuseIdentifier: String?

    public var reuseIdentifier: String {
        if let customReuseIdentifier = customReuseIdentifier {
            return customReuseIdentifier
        } else {
            return String(describing: viewClass)
        }
    }

    /**
     Initialize a ListHeader

     - parameter customReuseIdentifier: Set to override the default reuseIdentifier. Default is nil.
     - parameter configure: Generic block used to configure HeaderFooter. You must specify the UICollectionReusableView type.
     */
    public init<View: UIView>(customReuseIdentifier: String? = nil, configure: @escaping (View) -> Void) {
        self.customReuseIdentifier = customReuseIdentifier

        self.viewClass = View.self
        self.configure = { view in
            configure(view as! View)
        }
    }
}

// MARK: - Grid Header
/// Data structure representing a header or footer for a grid section
public struct GridHeader: DataSourceConfigurable {

    /// Configuration block for this HeaderFooter
    public var configure: ConfigureBlock

    public var viewClass: UIView.Type

    private var customReuseIdentifier: String?

    public var reuseIdentifier: String {
        if let customReuseIdentifier = customReuseIdentifier {
            return customReuseIdentifier
        } else {
            return String(describing: viewClass)
        }
    }

    /**
     Initialize a ListHeader

     - parameter customReuseIdentifier: Set to override the default reuseIdentifier. Default is nil.
     - parameter configure: Generic block used to configure HeaderFooter. You must specify the UICollectionReusableView type.
     */
    public init<View: UICollectionReusableView>(customReuseIdentifier: String? = nil, configure: @escaping (View) -> Void) {
        self.customReuseIdentifier = customReuseIdentifier
        
        self.viewClass = View.self
        self.configure = { view in
            configure(view as! View)
        }
    }
}
