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


// MARK: -

public protocol DataSourceConfigurable {
    var configure: ConfigureBlock { get }

    var viewClass: UIView.Type { get }

    var reuseIdentifier: String { get }
}


// MARK: -

public protocol DataSourceItem: DataSourceConfigurable {
    // The block that executes when the cell is tapped
    var onSelect: IndexPathBlock? { get set }

    // The block that executes when the cell is deleted
    var onDelete: IndexPathBlock? { get set }

    // Lets the dataSource know that this item can be reordered
    var reorderable: Bool { get set }
}


// MARK: -
/// UITableView delegate and dataSource with block-based constructors
public class DataSource: NSObject {
    
    /// The section data for the table view
    public var sections = [Section]()
    
    /// Callback for when a item is reordered
    public var onReorder: ReorderBlock?
    
    /// Callback for the UIScrollViewDelegate
    public var onScroll: ScrollBlock?
    
    /// Cell configuration middleware.
    /// Gets applied in DataSource order to cells matching the middleware cellClass type
    public var middlewareStack = [Middleware]()
    
    public override init() { super.init() }
    
    /**
     Initialize a DataSource
     
       - parameters:
         - sections: The array of sections in this DataSource
         - onReorder: Optional callback for when items are moved. You should update the order your underlying data in this callback. If this property is `nil`, reordering will be disabled for this TableView
         - onScroll: Optional callback for recieving scroll events from UIScrollViewDelegate
     */
    public init(sections: [Section], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil, middleware: [Middleware]? = nil) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
        if let middleware = middleware {
            self.middlewareStack = middleware
        }
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
    public convenience init(items: [DataSourceItem], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
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
    public subscript(indexPath: IndexPath) -> DataSourceItem {
        return sections[indexPath.section].items[indexPath.item]
    }


    // MARK: -
    /// Data structure representing the sections in the tableView
    public struct Section {
        
        /// The header data for this section
        public var header: HeaderFooter?
        
        /// The item data for this section
        public var items: [DataSourceItem]
        
        /// The footer data for this section
        public var footer: HeaderFooter?
        
        
        /**
         Initializer for a DataSource Section
         
           - parameters: 
             - header: The DataSource header data for this section
             - items: The items data for this section
             - footer: The DataSource footer data for this section
         */
        public init(header: HeaderFooter? = nil, items: [DataSourceItem], footer: HeaderFooter? = nil) {
            self.header = header
            self.items = items
            self.footer = footer
        }
        
        /// Convenience init for a section with a single item
        public init(header: HeaderFooter? = nil, item: DataSourceItem, footer: HeaderFooter? = nil) {
            self.header = header
            self.items = [item]
            self.footer = footer
        }
        
        // Reference items with `section[index]`
        public subscript(index: Int) -> DataSourceItem {
            return items[index]
        }
    }


    // MARK: -

    public struct ListItem: DataSourceItem {
        
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

    public struct GridItem: DataSourceItem {

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


    // MARK: -
    /// Data structure representing a header or footer for a grid section
    public struct HeaderFooter: DataSourceConfigurable {

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
         Initialize a HeaderFooter

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

}


// MARK: - Reusable Registration

public extension UITableView {
    @objc(registerReuseIdentifiersForDataSource:)
    public func registerReuseIdentifiers(forDataSource dataSource: DataSource) {
        for section in dataSource.sections {
            if let header = section.header {
                register(headerFooter: header)
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
                register(headerFooter: footer)
            }
        }
    }

    private func register(headerFooter: DataSource.HeaderFooter) {
        if let _ = Bundle.main.path(forResource: headerFooter.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: headerFooter.reuseIdentifier, bundle: nil)
            register(nib, forHeaderFooterViewReuseIdentifier: headerFooter.reuseIdentifier)
        } else {
            register(headerFooter.viewClass, forHeaderFooterViewReuseIdentifier: headerFooter.reuseIdentifier)
        }
    }
}

public extension UICollectionView {
    @objc(registerReuseIdentifiersForDataSource:)
    public func registerReuseIdentifiers(forDataSource dataSource: DataSource) {
        for section in dataSource.sections {
            if let header = section.header {
                register(headerFooter: header, kind: UICollectionElementKindSectionHeader)
            }
            for item in section.items {
                register(item: item)
            }
            if let footer = section.footer {
                register(headerFooter: footer, kind: UICollectionElementKindSectionFooter)
            }
        }
    }

    private func register(headerFooter: DataSource.HeaderFooter, kind: String) {
        if let _ = Bundle.main.path(forResource: headerFooter.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: headerFooter.reuseIdentifier, bundle: nil)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: headerFooter.reuseIdentifier)
        } else {
            register(headerFooter.viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: headerFooter.reuseIdentifier)
        }
    }

    private func register(item: DataSourceItem) {
        if let _ = Bundle.main.path(forResource: item.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: item.reuseIdentifier, bundle: Bundle.main)
            register(nib, forCellWithReuseIdentifier: item.reuseIdentifier)
        } else {
            register(item.viewClass, forCellWithReuseIdentifier: item.reuseIdentifier)
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
        // resonable default. can be overriden in configure block
        cell.selectionStyle = (item.onSelect != nil) ? UITableViewCellSelectionStyle.`default` : UITableViewCellSelectionStyle.none
        for middleware in middlewareStack {
            middleware.apply(cell)
        }
        item.configure(cell)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension DataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onSelect = self[indexPath].onSelect {
            onSelect(indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self[section].header else { return nil }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.reuseIdentifier) else { return nil }
        header.configure(view)
        return view
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let header = self[section].footer else { return nil }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.reuseIdentifier) else { return nil }
        header.configure(view)
        return view
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let header = self.tableView(tableView, viewForHeaderInSection: section) {
            return header.frame.height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footer = self.tableView(tableView, viewForFooterInSection: section) {
            return footer.frame.height
        } else {
            return UITableViewAutomaticDimension
        }
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
    
    @nonobjc public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
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

extension DataSource {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let onScroll = onScroll {
            onScroll(scrollView)
        }
    }
}
