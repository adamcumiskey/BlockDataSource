//
//  DataSourceItemBase.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import Foundation


// MARK: - DataSourceItemProtocol
/// A DataSourceReusable that can be selected, deleted, and reordered.
public protocol ItemProtocol: ReusableProtocol {
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
public class ItemBase: Reusable {
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
    init<T: UIView>(configure: @escaping (T) -> Void, onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = false, customReuseIdentifier: String? = nil) where T : UIView {
        super.init(customReuseIdentifier: customReuseIdentifier, configure: configure)
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.reorderable = reorderable
    }
}

// MARK: - Data Type Implementations

/// Base class that supports any UIView type
public class Item: ItemBase, ItemProtocol {
    public override init<T: UIView>(configure: @escaping (T) -> Void, onSelect: IndexPathBlock?, onDelete: IndexPathBlock?, reorderable: Bool, customReuseIdentifier: String?) where T : UIView {
        super.init(configure: configure, onSelect: onSelect, onDelete: onDelete, reorderable: reorderable, customReuseIdentifier: customReuseIdentifier)
    }
}

/// UITableViewCell
public class ListItem: Item {
    public override init<Cell: UITableViewCell>(configure: @escaping (Cell) -> Void, onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = true, customReuseIdentifier: String? = nil) {
        super.init(configure: configure, onSelect: onSelect, onDelete: onDelete, reorderable: reorderable, customReuseIdentifier: customReuseIdentifier)
    }
}

/// UICollectionViewCell
public class GridItem: Item {
    public override init<Cell: UICollectionViewCell>(configure: @escaping (Cell) -> Void, onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = true, customReuseIdentifier: String? = nil) {
        super.init(configure: configure, onSelect: onSelect, onDelete: onDelete, reorderable: reorderable, customReuseIdentifier: customReuseIdentifier)
    }
}


