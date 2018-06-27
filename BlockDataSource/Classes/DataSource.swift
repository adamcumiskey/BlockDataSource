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

/** Object that can act as the delegate and datasource for `UITableView`s and `UICollectionView`s.
 
  The block-based initialization provides an embedded DSL for creating `UITableViewController` and `UICollectionViewController`s.
*/
open class DataSource: NSObject {
    /// Array of `Section`s in the view
    public var sections: [Section]
    /// Block called when an `Item` is reordered. You must update the data backing the view inside this block.
    public var onReorder: ReorderBlock?
    /// Collection of callbacks used for handling `UIScrollViewDelegate` events
    public var scrollConfig: ScrollConfig?
    /// All the `Middleware` for this `DataSource`
    public var middleware: [Middleware]

    /**
     Initialize a `DataSource`

     - parameters:
     - sections: The array of sections in this `DataSource`
     - onReorder: Optional callback for when items are moved. You should update the order your underlying data in this callback. If this property is `nil`, reordering will be disabled for this TableView
     - onScroll: Optional callback for recieving scroll events from `UIScrollViewDelegate`
     - middleware: The `Middleware` for this `DataSource` to apply
     */
    public init(
        sections: [Section],
        onReorder: ReorderBlock? = nil,
        scrollConfig: ScrollConfig? = nil,
        middleware: [Middleware] = []
    ) {
        self.sections = sections
        self.onReorder = onReorder
        self.scrollConfig = scrollConfig
        self.middleware = middleware
    }
    
    /// Convenience initializer to construct a DataSource with a single section
    public convenience init(section: Section, onReorder: ReorderBlock? = nil, scrollConfig: ScrollConfig? = nil, middleware: [Middleware] = []) {
        self.init(sections: [section], onReorder: onReorder, scrollConfig: scrollConfig, middleware: middleware)
    }
    
    /// Convenience initializer to construct a DataSource with an array of items
    public convenience init(items: [Item], onReorder: ReorderBlock? = nil, scrollConfig: ScrollConfig? = nil, middleware: [Middleware] = []) {
        self.init(sections: [Section(items: items)], onReorder: onReorder, scrollConfig: scrollConfig, middleware: middleware)
    }

    /// Reference section with `DataSource[sectionIndex]`
    public subscript(sectionIndex: Int) -> Section {
        return sections[sectionIndex]
    }

    /// Reference item with `DataSource[indexPath]`
    public subscript(indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.item]
    }
}

extension DataSource {
    /// Stores blocks that allow the user to configure the `UIScrollViewDelegate` methods
    public struct ScrollConfig {
        public typealias WillEndDraggingBlock = ((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)
        public typealias DidEndDraggingBlock = ((UIScrollView, Bool) -> Void)

        /// Callback for when the scrollView is being dragged
        public let onScroll: ScrollBlock?
        /// Callback for when the scrollView is about to begin scrolling
        public let willBeginDragging: ScrollBlock?
        /// Callback for when the scrollView is about to stop dragging
        public let willEndDragging: WillEndDraggingBlock?
        /// Callback for when the scrollView dragging ends
        public let didEndDragging: DidEndDraggingBlock?
        /// Callback for when the scrollView stops scrolling
        public let didEndDecelerating: ScrollBlock?

        public init(
            onScroll: ScrollBlock? = nil,
            willBeginDragging: ScrollBlock? = nil,
            willEndDragging: WillEndDraggingBlock? = nil,
            didEndDragging: DidEndDraggingBlock? = nil,
            didEndDecelerating: ScrollBlock? = nil
            ) {
            self.onScroll = onScroll
            self.willBeginDragging = willBeginDragging
            self.willEndDragging = willEndDragging
            self.didEndDragging = didEndDragging
            self.didEndDecelerating = didEndDecelerating
        }
    }
}

// MARK: - Reusable

/// Represents the data for configuring a reusable view
/// You must specify the View class that a `Reusable` will represent in the `configure` closure.
/// View must be a subtype of `UITableViewCell`, `UITableViewHeaderFooterView`, `UICollectionViewCell`, `UICollectionReusableView`
public class Reusable {
    /// Store the generic view's type.
    public let viewClass: UIView.Type
    /// A block which takes a `UIView` and configures it
    public let configure: ConfigureBlock
    /// The reuse identifier to use when recycling the view element
    public var reuseIdentifier: String {
        if let customReuseIdentifier = customReuseIdentifier {
            return customReuseIdentifier
        } else {
            return String(describing: viewClass)
        }
    }
    
    private let customReuseIdentifier: String?

    /** Create a new reusable
     
     - parameters:
     - reuseIdentifier: Custom reuseIdentifier to use for this `Reusable`. Default is the view's classname.
     - configure
     */
    public init<View: UIView>(
        reuseIdentifier: String? = nil,
        configure: @escaping (View) -> Void
    ) {
        self.configure = { view in
            configure(view as! View)
        }
        self.viewClass = View.self
        self.customReuseIdentifier = reuseIdentifier
    }
}

// MARK: - Item

/// Object used to configure a UITableViewCell or UICollectionViewCell
public class Item: Reusable {
    public let onSelect: IndexPathBlock?
    public let onDelete: IndexPathBlock?
    public let reorderable: Bool

    /**
     Initialize an item

     - parameters:
     - configure: The configuration block.
     - onSelect: The closure to execute when the item is tapped
     - onDelete: The closure to execute when the item is deleted
     - reuseIdentifier: Custom reuseIdentifier to use for this Item
     - reorderable: Allows this cell to be reordered when editing when true
     */
    public init<View: UIView>(
        configure: @escaping (View) -> Void,
        onSelect: IndexPathBlock? = nil,
        onDelete: IndexPathBlock? = nil,
        reuseIdentifier: String? = nil,
        reorderable: Bool = false
    ) {
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.reorderable = reorderable
        super.init(reuseIdentifier: reuseIdentifier, configure: configure)
    }

    /// Convenience initializer for trailing closure initialization
    public convenience init<View: UIView>(
        reuseIdentifier: String? = nil,
        reorderable: Bool = false,
        configure: @escaping (View) -> Void
    ) {
        self.init(configure: configure, reuseIdentifier: reuseIdentifier, reorderable: reorderable)
    }
}

// MARK: - Section

/// Data structure that wraps an array of items to represent a tableView/collectionView section.
public struct Section {
    /// A Reusable for this section's header
    public var header: Reusable?
    /// The item data for this section
    public var items: [Item]
    /// A Reusable for this section's footer
    public var footer: Reusable?
    
    /// Header text for UITableView section
    public var headerText: String?
    /// Footer text for UITableView section
    public var footerText: String?
    
    public init(
        header: Reusable? = nil,
        headerText: String? = nil,
        items: [Item],
        footer: Reusable? = nil,
        footerText: String? = nil
    ) {
        self.header = header
        self.headerText = headerText
        self.items = items
        self.footer = footer
        self.footerText = footerText
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
/// CAUTION: Middleware is currently very inefficient. Every time a cell is about to be reconfigured it reapplies the midleware in O(n) time.
/// I haven't experinced performance issues but YMMV.
public struct Middleware {
    public typealias ApplyFunction = (UIView, IndexPath, [Section]) -> Void
    public var apply: ApplyFunction

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

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self[section].headerText
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self[section].footerText
    }

    @nonobjc public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let item = self[indexPath]
        return item.onDelete != nil || item.reorderable == true
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let onDelete = self[indexPath].onDelete {
                sections[indexPath.section].items.remove(at: indexPath.item)
                // TODO: make configurable
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                onDelete(indexPath)
            }
        }
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self[indexPath].reorderable
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

// MARK: - UITableViewDelegate

extension DataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        middleware.forEach { $0.apply(cell, indexPath, self.sections) }
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = self[section].header else { return }
        header.configure(view)
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = self[section].footer else { return }
        footer.configure(view)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onSelect = self[indexPath].onSelect {
            onSelect(indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, viewForHeaderInSection: section) != nil || self[section].headerText != nil {
            return UITableViewAutomaticDimension
        } else {
            return 0
        }
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.tableView(tableView, viewForFooterInSection: section) != nil {
            return UITableViewAutomaticDimension
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self[section].header else { return nil }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.reuseIdentifier) else { return nil }
        return view
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = self[section].footer else { return nil }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footer.reuseIdentifier) else { return nil }
        footer.configure(view)
        return view
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard let _ = self[indexPath].onDelete else { return .none }
        return .delete
    }

    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return self[proposedDestinationIndexPath].reorderable ? proposedDestinationIndexPath : sourceIndexPath
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
        middleware.forEach { $0.apply(cell, indexPath, self.sections) }
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
        if let onScroll = scrollConfig?.onScroll {
            onScroll(scrollView)
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let willBeginDragging = scrollConfig?.willBeginDragging {
            willBeginDragging(scrollView)
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let willEndDragging = scrollConfig?.willEndDragging {
            willEndDragging(scrollView, velocity, targetContentOffset)
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let didEndDragging = scrollConfig?.didEndDragging {
            didEndDragging(scrollView, decelerate)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let didEndDecelerating = scrollConfig?.didEndDecelerating {
            didEndDecelerating(scrollView)
        }
    }
}

// MARK: - Cell Registration

public extension UITableView {
    public func registerReuseIdentifiers(forDataSource dataSource: DataSource) {
        for section in dataSource.sections {
            if let header = section.header {
                register(sectionDecoration: header)
            }
            for item in section.items {
                if let _ = Bundle.main.path(forResource: item.reuseIdentifier, ofType: "nib") {
                    let nib = UINib(nibName: item.reuseIdentifier, bundle: Bundle.main)
                    register(nib, forCellReuseIdentifier: item.reuseIdentifier)
                } else {
                    register(item.viewClass, forCellReuseIdentifier: item.reuseIdentifier)
                }
            }
            if let footer = section.footer {
                register(sectionDecoration: footer)
            }
        }
    }

    private func register(sectionDecoration: Reusable) {
        if let _ = Bundle.main.path(forResource: sectionDecoration.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: sectionDecoration.reuseIdentifier, bundle: nil)
            register(nib, forHeaderFooterViewReuseIdentifier: sectionDecoration.reuseIdentifier)
        } else {
            register(sectionDecoration.viewClass, forHeaderFooterViewReuseIdentifier: sectionDecoration.reuseIdentifier)
        }
    }
}

public extension UICollectionView {
    public func registerReuseIdentifiers(forDataSource dataSource: DataSource) {
        for section in dataSource.sections {
            if let header = section.header {
                register(sectionDecoration: header, kind: UICollectionElementKindSectionHeader)
            }
            for item in section.items {
                register(item: item)
            }
            if let footer = section.footer {
                register(sectionDecoration: footer, kind: UICollectionElementKindSectionFooter)
            }
        }
    }

    private func register(sectionDecoration: Reusable, kind: String) {
        if let _ = Bundle.main.path(forResource: sectionDecoration.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: sectionDecoration.reuseIdentifier, bundle: nil)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: sectionDecoration.reuseIdentifier)
        } else {
            register(sectionDecoration.viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: sectionDecoration.reuseIdentifier)
        }
    }

    private func register(item: Item) {
        if let _ = Bundle.main.path(forResource: item.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: item.reuseIdentifier, bundle: Bundle.main)
            register(nib, forCellWithReuseIdentifier: item.reuseIdentifier)
        } else {
            register(item.viewClass, forCellWithReuseIdentifier: item.reuseIdentifier)
        }
    }
}

// MARK: - Helpers

extension Array {
    mutating func moveObjectAtIndex(_ index: Int, toIndex: Int) {
        let element = self[index]
        remove(at: index)
        insert(element, at: toIndex)
    }
}
