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
//  List.swift
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.


import Foundation


/// UITableView delegate and dataSource with block-based constructors
public class List: NSObject {
    
    /// The section data for the table view
    public var sections = [Section]()
    
    /// Callback for when a row is reordered
    public var onReorder: ReorderBlock?
    
    /// Callback for the UIScrollViewDelegate
    public var onScroll: ScrollBlock?
    
    /// Cell configuration middleware.
    /// Gets applied in list order to cells matching the middleware cellClass type
    public var middlewareStack = [Middleware]()
    
    public override init() { super.init() }
    
    /**
     Initialize a List
     
       - parameters:
         - sections: The array of sections in this List
         - onReorder: Optional callback for when rows are moved. You should update the order your underlying data in this callback. If this property is `nil`, reordering will be disabled for this TableView
         - onScroll: Optional callback for recieving scroll events from UIScrollViewDelegate
     */
    public init(sections: [Section], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
    
    /// Convenience init for a List with a single section
    public convenience init(section: Section, onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [section],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }
    
    /// Convenience init for a List with a single section with no headers/footers
    public convenience init(rows: [Row], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [Section(rows: rows)], 
            onReorder: onReorder, 
            onScroll: onScroll
        )
    }
    
    // Reference section with `list[index]`
    public subscript(index: Int) -> Section {
        return sections[index]
    }
    
    // Reference row with `list[indexPath]`
    public subscript(indexPath: IndexPath) -> Row {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    
    /// Data structure representing the sections in the tableView
    public struct Section {
        
        /// The header data for this section
        public var header: HeaderFooter?
        
        /// The row data for this section
        public var rows: [Row]
        
        /// The footer data for this section
        public var footer: HeaderFooter?
        
        
        /**
         Initializer for a List Section
         
           - parameters: 
             - header: The list header data for this section
             - rows: The rows data for this section
             - footer: The list footer data for this section
         */
        public init(header: HeaderFooter? = nil, rows: [Row], footer: HeaderFooter? = nil) {
            self.header = header
            self.rows = rows
            self.footer = footer
        }
        
        /// Convenience init for a section with a single row
        public init(header: HeaderFooter? = nil, row: Row, footer: HeaderFooter? = nil) {
            self.header = header
            self.rows = [row]
            self.footer = footer
        }
        
        // Reference rows with `section[index]`
        public subscript(index: Int) -> Row {
            return rows[index]
        }
        
        
        /// Enum representing the header or footer data for a list section
        public enum HeaderFooter {
            /// Provide a text label as the header/footer for the section
            case label(String)
            
            /// Provide a custom view as the header/footer for the section
            case customView(UIView, height: CGFloat)
            
            /// Convenience accessor for the label text. Will return `nil` if the type is `.customView`
            public var text: String? {
                switch self {
                case let .label(text):
                    return text
                default:
                    return nil
                }
            }
            
            /// Convenience accessor for the view. Will be `nil` if the type is `.label`
            public var view: UIView? {
                switch self {
                case let .customView(view, _):
                    return view
                default:
                    return nil
                }
            }
        }
    }
    
    
    ///
    public struct Row {
        
        // The block which configures the cell
        var configure: ConfigureRow
        
        // The block that executes when the cell is tapped
        public var onSelect: IndexPathBlock?
        
        // The block that executes when the cell is deleted
        public var onDelete: IndexPathBlock?
        
        // Lets the dataSource know that this row can be reordered
        public var reorderable: Bool = false
        
        
        /**
         Initialize a row
         
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
            
            self.cellClass = Cell.self
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
        
        
        // MARK: Private
        
        fileprivate var cellClass: UITableViewCell.Type
        
        private var customReuseIdentifier: String?
        
        fileprivate var reuseIdentifier: String {
            if let customReuseIdentifier = customReuseIdentifier {
                return customReuseIdentifier
            } else {
                return String(describing: cellClass)
            }
        }
    }
}


// MARK: - Reusable Registration

public extension List {
    @objc(registerReuseIdentifiersToTableView:)
    public func registerReuseIdentifiers(to tableView: UITableView) {
        for section in sections {
            for row in section.rows {
                if let _ = Bundle.main.path(forResource: row.reuseIdentifier, ofType: "nib") {
                    let nib = UINib(nibName: row.reuseIdentifier, bundle: Bundle.main)
                    tableView.register(nib, forCellReuseIdentifier: row.reuseIdentifier)
                } else {
                    tableView.register(row.cellClass, forCellReuseIdentifier: row.reuseIdentifier)
                }
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension List: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self[indexPath]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        // resonable default. can be overriden in configure block
        cell.selectionStyle = (row.onSelect != nil) ? UITableViewCellSelectionStyle.`default` : UITableViewCellSelectionStyle.none
        row.configure(cell)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        for middleware in middlewareStack {
            middleware.apply(cell, indexPath, self.sections)
        }
    }
}


// MARK: - UITableViewDelegate

extension List: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onSelect = self[indexPath].onSelect {
            onSelect(indexPath)
        }
    }
    
    @nonobjc public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self[section].header?.text
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self[section].header?.view
    }
    
    @nonobjc public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self[section].footer?.text
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self[section].footer?.view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = self[section].header else { return UITableViewAutomaticDimension }
        switch header {
        case .label(_):
            return UITableViewAutomaticDimension
        case let .customView(_, height):
            return height
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footer = self[section].footer else { return UITableViewAutomaticDimension }
        switch footer {
        case .label(_):
            return UITableViewAutomaticDimension
        case let .customView(_, height):
            return height
        }
    }
    
    @nonobjc public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = self[indexPath]
        return row.onDelete != nil || row.reorderable == true
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard let _ = self[indexPath].onDelete else { return .none }
        return .delete
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let onDelete = self[indexPath].onDelete {
                sections[indexPath.section].rows.remove(at: indexPath.row)
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
                sections[sourceIndexPath.section].rows.moveObjectAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
            } else {
                let row = sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
                sections[destinationIndexPath.section].rows.insert(row, at: destinationIndexPath.row)
            }
            reorder(sourceIndexPath, destinationIndexPath)
        }
    }
}


// MARK: - UIScrollViewDelegate

extension List {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let onScroll = onScroll {
            onScroll(scrollView)
        }
    }
}
