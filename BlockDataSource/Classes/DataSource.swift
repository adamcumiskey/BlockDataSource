//  The MIT License (MIT)
//
//  Copyright (c) 2016 Adam Cumiskey
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//
//  DataSource.swift
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.


import Foundation


public typealias ConfigureBlock = (UIView) -> Void
public typealias IndexPathBlock = (_ indexPath: IndexPath) -> Void
public typealias ReorderBlock = (_ sourceIndex: IndexPath, _ destinationIndex: IndexPath) -> Void
public typealias ScrollBlock = (_ scrollView: UIScrollView) -> Void


// MARK: - DataSource

/// Object that can act as the delegate and datasource for UITableViews and UICollectionViews.
/// The block based initialization allows tables and collections to be created with a DSL-like syntax.
public class DataSource: NSObject {
    public var sections: [Section]
    public var onReorder: ReorderBlock?
    public var onScroll: ScrollBlock?
    public var middleware: [Middleware]

    /**
     Initialize a DataSource

     - parameters:
     - sections: The array of sections in this DataSource
     - onReorder: Optional callback for when items are moved. You should update the order your underlying data in this callback. If this property is `nil`, reordering will be disabled for this TableView
     - onScroll: Optional callback for recieving scroll events from UIScrollViewDelegate
     */
    public init(sections: [Section], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil, middleware: [Middleware] = []) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
        self.middleware = middleware
    }

    public convenience override init() {
        self.init(items: [])
    }

    /// Convenience init for a DataSource with a single section
    public convenience init(section: Section, onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [section],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }

    /// Convenience init for a DataSource with a single section with no headers/footers
    public convenience init(items: [Item], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [Section(items: items)],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }

    // Reference section with `DataSource[index]`
    public subscript(index: Int) -> Section {
        return sections[index]
    }

    // Reference item with `DataSource[indexPath]`
    public subscript(indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.item]
    }
}


// MARK: - Reusable

/// Represents the data for configuring a reusable view
/// You must specify the View class that a Reusable will represent in the `configure` closure.
/// View must be a subtype of UITableViewCell, UITableViewHeaderFooterView, UICollectionViewCell, UICollectionReusableView
public class Reusable {
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

    public init<View: UIView>(customReuseIdentifier: String? = nil, configure: @escaping (View) -> Void) {
        self.configure = { view in
            configure(view as! View)
        }
        self.viewClass = View.self
    }
}


// MARK: - Item

/// Object used to configure UITableViewCell or UICollectionViewCells
public class Item: Reusable {
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
    public init<T: UIView>(onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = false, customReuseIdentifier: String? = nil, configure: @escaping (T) -> Void) where T : UIView {
        super.init(customReuseIdentifier: customReuseIdentifier, configure: configure)
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.reorderable = reorderable
    }
}


// MARK: - Section

/// Data structure that wraps an array of items to represent a tableView/collectionView section.
public struct Section {
    /// The header data for this section
    public var header: Reusable?

    /// The item data for this section
    public var items: [Item]

    /// The footer data for this section
    public var footer: Reusable?

    /**
     Initializer for a DataSource Section

     - parameters:
     - header: The header item for this section
     - items: The items data for this section
     - footer: The DataSource footer data for this section
     */
    public init(header: Reusable? = nil, items: [Item], footer: Reusable? = nil) {
        self.header = header
        self.items = items
        self.footer = footer
    }

    /// Convenience init for a section with a single item
    public init(header: Reusable? = nil, item: Item, footer: Reusable? = nil) {
        self.header = header
        self.items = [item]
        self.footer = footer
    }

    // Reference items with `section[index]`
    public subscript(index: Int) -> Item {
        return items[index]
    }
}


// MARK: - Middleware

/// Middleware allows you to customize for specific table/collection view cells in a generic way.
///
/// The datasource will apply its middleware to any views matching the type passed into the `apply` closure.
/// Passing in a type of UICollectionViewCell or UITableViewCell will cause the middleware to be applied to
/// all items. The indexPath of the item that the middleware is being applied to as well as the dataSource structure are also
/// passed in to allow the middleware to be aware of context.
///
/// NOTE: This is probably not production ready as applying all the middleware to each cell is O(n) 
public struct Middleware {
    public var apply: (UIView, IndexPath, [Section]) -> Void
    public init<View: UIView>(apply: @escaping (View, IndexPath, [Section]) -> Void) {
        self.apply = { view, indexPath, sections in
            if let view = view as? View {
                apply(view, indexPath, sections)
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension DataSource: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self[indexPath]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension DataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        for middleware in middleware {
            middleware.apply(cell, indexPath, self.sections)
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onSelect = self[indexPath].onSelect {
            onSelect(indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self[section].header else { return nil }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.reuseIdentifier) else { return nil }
        return view
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let header = self.tableView(tableView, viewForHeaderInSection: section) {
            return header.frame.height
        } else {
            return UITableViewAutomaticDimension
        }
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = self[section].header else { return }
        header.configure(view)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = self[section].footer else { return nil }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footer.reuseIdentifier) else { return nil }
        footer.configure(view)
        return view
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footer = self.tableView(tableView, viewForFooterInSection: section) {
            return footer.frame.height
        } else {
            return UITableViewAutomaticDimension
        }
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = self[section].footer else { return }
        footer.configure(view)
    }

    @nonobjc public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let item = self[indexPath]
        return item.onDelete != nil || item.reorderable == true
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard let _ = self[indexPath].onDelete else { return .none }
        return .delete
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let onDelete = self[indexPath].onDelete {
                sections[indexPath.section].items.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                onDelete(indexPath)
            }
        }
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self[indexPath].reorderable
    }

    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return self[proposedDestinationIndexPath].reorderable ? proposedDestinationIndexPath : sourceIndexPath
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let reorder = onReorder {
            if sourceIndexPath.section == destinationIndexPath.section {
                sections[sourceIndexPath.section].items.moveObjectAtIndex(sourceIndexPath.item, toIndex: destinationIndexPath.item)
            } else {
                let item = sections[sourceIndexPath.section].items.remove(at: sourceIndexPath.item)
                sections[destinationIndexPath.section].items.insert(item, at: destinationIndexPath.item)
            }
            reorder(sourceIndexPath, destinationIndexPath)
        }
    }
}


// MARK: - UICollectionViewDataSource

extension DataSource: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection sectionIndex: Int) -> Int {
        return self[sectionIndex].items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        return cell
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        guard onReorder != nil else { return false }
        return self[indexPath].reorderable
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let reorder = onReorder {
            // Reorder the items
            if sourceIndexPath.section == destinationIndexPath.section {
                sections[sourceIndexPath.section].items.moveObjectAtIndex(sourceIndexPath.item, toIndex: destinationIndexPath.item)
            } else {
                let item = sections[sourceIndexPath.section].items.remove(at: sourceIndexPath.item)
                sections[destinationIndexPath.section].items.insert(item, at: destinationIndexPath.item)
            }
            // Update data model in this callback
            reorder(sourceIndexPath, destinationIndexPath)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self[indexPath.section]
        if kind == UICollectionElementKindSectionHeader {
            guard let header = section.header else { return UICollectionReusableView() }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header.reuseIdentifier, for: indexPath)
            header.configure(view)
            return view
        } else if kind == UICollectionElementKindSectionFooter {
            guard let footer = section.footer else { return UICollectionReusableView() }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footer.reuseIdentifier, for: indexPath)
            footer.configure(view)
            return view
        }
        return UICollectionReusableView()
    }
}


// MARK: - UICollectionViewDelegate

extension DataSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        for middleware in middleware {
            middleware.apply(cell, indexPath, self.sections)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return self[indexPath].onSelect != nil
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let onSelect = self[indexPath].onSelect {
            onSelect(indexPath)
        }
    }
}


// MARK: - UIScrollViewDelegate

extension DataSource: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let onScroll = onScroll {
            onScroll(scrollView)
        }
    }
}
