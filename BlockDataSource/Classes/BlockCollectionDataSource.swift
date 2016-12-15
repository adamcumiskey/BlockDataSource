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
//  Collection.swift
//
//  Created by Adam Cumiskey on 12/07/16.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.


import Foundation

public typealias ConfigureCollectionItem = (UICollectionViewCell) -> Void
public typealias ConfigureCollectionHeaderFooter = (UICollectionReusableView) -> Void


// MARK: - Collection

public class CollectionData: NSObject {
    public var sections: [Section]
    public var onReorder: ReorderBlock?
    public var onScroll: ScrollBlock?
    
    public override init() {
        self.sections = [Section]()
        super.init()
    }
    
    public init(sections: [Section], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
    
    // MARK: - Item
    
    public struct Item {
        var cellClass: UICollectionViewCell.Type
        var reuseIdentifier: String { return String(describing: cellClass) }
        
        var configure: ConfigureCollectionItem
        public var onSelect: IndexPathBlock?
        public var onDelete: IndexPathBlock?
        public var reorderable = false
        
        public init<Cell: UICollectionViewCell>(reorderable: Bool = false, configure: @escaping (Cell) -> ()) {
            self.reorderable = reorderable
            self.onSelect = nil
            self.onDelete = nil
            
            self.cellClass = Cell.self
            self.configure = { cell in
                configure(cell as! Cell)
            }
        }
        
        public init<Cell: UICollectionViewCell>(configure: @escaping (Cell) -> (), onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, reorderable: Bool = false) {
            self.cellClass = Cell.self
            self.configure = { cell in
                configure(cell as! Cell)
            }
            
            self.onSelect = onSelect
            self.onDelete = onDelete
            self.reorderable = reorderable
        }
    }
    
    // MARK: - Section
    
    public struct Section {
        public struct HeaderFooter {
            var configure: ConfigureCollectionHeaderFooter
            var viewClass: UICollectionReusableView.Type
            var reuseIdentifier: String { return String(describing: viewClass) }
            
            public init<View: UICollectionReusableView>(configure: @escaping (View) -> Void) {
                self.viewClass = View.self
                self.configure = { view in
                    configure(view as! View)
                }
            }
        }
        
        public var header: HeaderFooter?
        public var items: [Item]
        public var footer: HeaderFooter?
        
        
        public init(header: HeaderFooter? = nil, items: [Item], footer: HeaderFooter? = nil) {
            self.header = header
            self.items = items
            self.footer = footer
        }
    }
}


// MARK: - Reusable Registration

public extension CollectionData {
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

extension CollectionData: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionAtIndex(section)?.items.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemAtIndexPath(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        guard onReorder != nil else { return false }
        return itemAtIndexPath(indexPath).reorderable
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let reorder = onReorder {
            reorder(sourceIndexPath, destinationIndexPath)
            collectionView.reloadData()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = sectionAtIndex(indexPath.section) else { return UICollectionReusableView() }
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

extension CollectionData: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return itemAtIndexPath(indexPath).onSelect != nil
    }
 
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let onSelect = itemAtIndexPath(indexPath).onSelect {
            onSelect(indexPath)
        }
    }
}


// MARK: - Helpers

extension CollectionData {
    fileprivate func itemAtIndexPath(_ indexPath: IndexPath) -> Item {
        let section = sections[indexPath.section]
        return section.items[indexPath.row]
    }
    
    fileprivate func sectionAtIndex(_ index: Int) -> Section? {
        guard sections.count > index else { return nil }
        return sections[index]
    }
}
