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
//  Grid.swift
//
//  Created by Adam Cumiskey on 12/07/16.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.


import Foundation


/// UICollectionView delegate and dataSource with block-based constructors
public class Grid: NSObject {
    
    /// The section data for the collection view
    public var sections: [Section]
    
    /// Callback for when an item is reordered
    public var onReorder: ReorderBlock?
    
    /// Callback for the UIScrollViewDelegate
    public var onScroll: ScrollBlock?
    
    
    /// Initialize an empty Grid
    public override init() {
        self.sections = [Section]()
        super.init()
    }
    
    /**
     Initialize a Grid

       - parameters:
         - sections: The array of sections in this Grid
         - onReorder: Optional callback for when items are moved. You should update the order your underlying data in this callback. If this property is `nil`, reordering will be disabled for this CollectionView.
         - onScroll: Optional callback for recieving scroll events from UIScrollViewDelegate
     */
    public init(sections: [Section], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
    
    /// Convenience init for a Grid with a single section
    public convenience init(section: Section, onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [section],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }
    
    /// Convenience init for a Grid with a single section with no headers/footers
    public convenience init(items: [Item], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [Section(items: items)],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }
    
    /// Reference sections with `grid[index]`
    public subscript(index: Int) -> Section {
        return sections[index]
    }
    
    /// Reference items with `grid[indexPath]`
    public subscript(indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.item]
    }
    
    
    /// Data structure representing the sections in the collectionView
    public struct Section {
        
        /// The header data for this section
        public var header: HeaderFooter?
        
        /// The item data for this section
        public var items: [Item]
        
        /// The footer data for this section
        public var footer: HeaderFooter?
        
        
        /**
         Initialize a Section
         
           - parameters:
             - header: The header data for this section
             - items: The item data in this section
             - footer: The footer data for this section
         */
        public init(header: HeaderFooter? = nil, items: [Item], footer: HeaderFooter? = nil) {
            self.header = header
            self.items = items
            self.footer = footer
        }
        
        /// Reference items with `section[index]`
        public subscript(index: Int) -> Item {
            return items[index]
        }
        
        
        /// Data structure representing a header or footer for a grid section
        public struct HeaderFooter {
            
            /// Configuration block for this HeaderFooter
            var configure: ConfigureCollectionHeaderFooter
            
            
            /**
             Initialize a HeaderFooter
             
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
            
            
            // MARK: Private
            
            fileprivate var viewClass: UICollectionReusableView.Type
            
            private var customReuseIdentifier: String?
            
            fileprivate var reuseIdentifier: String {
                if let customReuseIdentifier = customReuseIdentifier {
                    return customReuseIdentifier
                } else {
                    return String(describing: viewClass)
                }
            }
        }
    }
    
    // Data structure representing an Item in the collection view
    public struct Item {
        
        /// Configuration block for the cell
        var configure: ConfigureCollectionItem
        
        /// Closure that executes when the cell is tapped
        public var onSelect: IndexPathBlock?
        
        /// Closure that executes when the cell is deleted
        public var onDelete: IndexPathBlock?
        
        /// Boolean flag for if the cell can be reordered
        public var reorderable = false
        
        
        /**
         Initialize an item
         
         - parameters:
           - configure: The cell configuration block
           - onSelect: The closure to execute when the cell is tapped
           - onDelete: The closure to execute when the cell is deleted
           - reorderable: Flag to indicate if this cell can be reordered
           - customReuseIdentifier: Set to override the default reuseIdentifier. Default is nil.
         */
        public init<Cell: UICollectionViewCell>(configure: @escaping (Cell) -> (), onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = false, customReuseIdentifier: String? = nil) {
            self.cellClass = Cell.self
            self.configure = { cell in
                configure(cell as! Cell)
            }
            
            self.onSelect = onSelect
            self.onDelete = onDelete
            self.reorderable = reorderable
            self.customReuseIdentifier = customReuseIdentifier
        }
        
        /// Convenience initializer for trialing closure syntax
        public init<Cell: UICollectionViewCell>(reorderable: Bool = false, configure: @escaping (Cell) -> ()) {
            self.reorderable = reorderable
            self.onSelect = nil
            self.onDelete = nil
            
            self.cellClass = Cell.self
            self.configure = { cell in
                configure(cell as! Cell)
            }
        }
        
        
        // MARK: Private
        
        fileprivate var cellClass: UICollectionViewCell.Type
        
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

public extension Grid {
    @objc(registerReuseIdentifiersToCollectionView:)
    public func registerReuseIdentifiers(to collectionView: UICollectionView) {
        for section in sections {
            if let header = section.header {
                register(headerFooter: header, kind: UICollectionElementKindSectionHeader, toCollectionView: collectionView)
            }
            for item in section.items {
                register(item: item, toCollectionView: collectionView)
            }
            if let footer = section.footer {
                register(headerFooter: footer, kind: UICollectionElementKindSectionFooter, toCollectionView: collectionView)
            }
        }
    }
    
    private func register(headerFooter: Section.HeaderFooter, kind: String, toCollectionView collectionView: UICollectionView) {
        if let _ = Bundle.main.path(forResource: headerFooter.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: headerFooter.reuseIdentifier, bundle: nil)
            collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: headerFooter.reuseIdentifier)
        } else {
            collectionView.register(headerFooter.viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: headerFooter.reuseIdentifier)
        }
    }
    
    private func register(item: Item, toCollectionView collectionView: UICollectionView) {
        if let _ = Bundle.main.path(forResource: item.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: item.reuseIdentifier, bundle: Bundle.main)
            collectionView.register(nib, forCellWithReuseIdentifier: item.reuseIdentifier)
        } else {
            collectionView.register(item.cellClass, forCellWithReuseIdentifier: item.reuseIdentifier)
        }
    }
}


// MARK: - UICollectionViewDataSource

extension Grid: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection sectionIndex: Int) -> Int {
        return self[sectionIndex].items.count 
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
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

extension Grid: UICollectionViewDelegate {
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

extension Grid: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let onScroll = onScroll {
            onScroll(scrollView)
        }
    }
}
