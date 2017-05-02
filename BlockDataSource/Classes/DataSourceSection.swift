//
//  DataSourceSection.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import Foundation


// MARK: -
/// Data structure representing the sections in the tableView
public struct Section<Item: DataSourceItem> {

    /// The header data for this section
    public var header: Item.HeaderType?

    /// The item data for this section
    public var items: [Item]

    /// The footer data for this section
    public var footer: Item.HeaderType?


    /**
     Initializer for a DataSource Section

     - parameters:
     - header: The DataSource header data for this section
     - items: The items data for this section
     - footer: The DataSource footer data for this section
     */
    public init(header: Item.HeaderType? = nil, items: [Item], footer: Item.HeaderType? = nil) {
        self.header = header
        self.items = items
        self.footer = footer
    }

    /// Convenience init for a section with a single item
    public init(header: Item.HeaderType? = nil, item: Item, footer: Item.HeaderType? = nil) {
        self.header = header
        self.items = [item]
        self.footer = footer
    }

    // Reference items with `section[index]`
    public subscript(index: Int) -> Item {
        return items[index]
    }
}
