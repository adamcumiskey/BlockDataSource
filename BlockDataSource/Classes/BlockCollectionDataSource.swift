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
//  BlockCollectionDataSource.swift
//
//  Created by Adam Cumiskey on 12/07/16.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.


import Foundation


// MARK: - Item

public struct CollectionItem {
    var cellClass: UICollectionViewCell.Type
    var reuseIdentifier: String { return String(describing: cellClass) }
    
    var configure: (UICollectionViewCell) -> ()
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

public struct CollectionSection {
    var headerClass: UICollectionReusableView.Type?
    var configureHeader: ((UICollectionReusableView) -> ())?
    var headerReuseIdentifier: String? {
        guard let headerClass = headerClass else { return nil }
        return String(describing: headerClass)
    }
    
    public var items: [CollectionItem]
    
    var footerClass: UICollectionReusableView.Type?
    var configureFooter: ((UICollectionReusableView) -> ())?
    var footerReuseIdentifier: String? {
        guard let footerClass = footerClass else { return nil }
        return String(describing: footerClass)
    }
    
    
    public init<Header: UICollectionReusableView, Footer: UICollectionReusableView>(configureHeader: ((Header) -> ())? = nil, items: [CollectionItem], configureFooter: ((Footer) -> ())? = nil) {
        if let configureHeader = configureHeader {
            self.headerClass = Header.self
            self.configureHeader = { header in
                configureHeader(header as! Header)
            }
        }
        
        self.items = items
        
        if let configureFooter = configureFooter {
            self.footerClass = Footer.self
            self.configureFooter = { footer in
                configureFooter(footer as! Footer)
            }
        }
    }
}


// MARK: - BlockCollectionDataSource

public class BlockCollectionDataSource: NSObject {
    public var sections: [CollectionSection]
    public var onReorder: ReorderBlock?
    public var onScroll: ScrollBlock?
    
    public override init() {
        self.sections = [CollectionSection]()
        super.init()
    }
    
    public init(sections: [CollectionSection], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
}


// MARK: - Reusable Registration

public extension BlockCollectionDataSource {
    @objc(registerReuseIdentifiersToCollectionView:)
    public func registerReuseIdentifiers(to collectionView: UICollectionView) {
        for section in sections {
            if let headerViewClass = section.headerClass {
                let reuseIdentifier = String(describing: headerViewClass)
                if let _ = Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") {
                    let nib = UINib(nibName: reuseIdentifier, bundle: nil)
                    collectionView.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
                } else {
                    collectionView.register(headerViewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
                }
            }
            for item in section.items {
                if let _ = Bundle.main.path(forResource: item.reuseIdentifier, ofType: "nib") {
                    let nib = UINib(nibName: item.reuseIdentifier, bundle: Bundle.main)
                    collectionView.register(nib, forCellWithReuseIdentifier: item.reuseIdentifier)
                } else {
                    collectionView.register(item.cellClass, forCellWithReuseIdentifier: item.reuseIdentifier)
                }
            }
            if let footerViewClass = section.footerClass {
                let reuseIdentifier = String(describing: footerViewClass)
                if let _ = Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") {
                    let nib = UINib(nibName: reuseIdentifier, bundle: nil)
                    collectionView.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reuseIdentifier)
                } else {
                    collectionView.register(footerViewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reuseIdentifier)
                }
            }
        }
    }
}


// MARK: - UICollectionViewDataSource

extension BlockCollectionDataSource: UICollectionViewDataSource {
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
            guard let reuseIdentifier = section.headerReuseIdentifier else { return UICollectionReusableView() }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
            section.configureHeader?(view)
            return view
        } else if kind == UICollectionElementKindSectionFooter {
            guard let reuseIdentifier = section.footerReuseIdentifier else { return UICollectionReusableView() }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
            section.configureFooter?(view)
            return view
        }
        return UICollectionReusableView()
    }
}



// MARK: - UICollectionViewDelegate

extension BlockCollectionDataSource: UICollectionViewDelegate {
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

extension BlockCollectionDataSource {
    fileprivate func itemAtIndexPath(_ indexPath: IndexPath) -> CollectionItem {
        let section = sections[indexPath.section]
        return section.items[indexPath.row]
    }
    
    fileprivate func sectionAtIndex(_ index: Int) -> CollectionSection? {
        guard sections.count > index else { return nil }
        return sections[index]
    }
}
