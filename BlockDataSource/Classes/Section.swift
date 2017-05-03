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
public struct Section<DataSourceType: DataSourceTypeProtocol> {

    /// The header data for this section
    public var header: DataSourceType.Decoration?

    /// The item data for this section
    public var items: [DataSourceType.Item]

    /// The footer data for this section
    public var footer: DataSourceType.Decoration?

    /**
     Initializer for a DataSource Section

     - parameters:
     - header: The DataSource header data for this section
     - items: The items data for this section
     - footer: The DataSource footer data for this section
     */
    public init(header: DataSourceType.Decoration? = nil, items: [DataSourceType.Item], footer: DataSourceType.Decoration? = nil) {
        self.header = header
        self.items = items
        self.footer = footer
    }

    /// Convenience init for a section with a single item
    public init(header: DataSourceType.Decoration? = nil, item: DataSourceType.Item, footer: DataSourceType.Decoration? = nil) {
        self.header = header
        self.items = [item]
        self.footer = footer
    }

    // Reference items with `section[index]`
    public subscript(index: Int) -> DataSourceType.Item {
        return items[index]
    }
}
