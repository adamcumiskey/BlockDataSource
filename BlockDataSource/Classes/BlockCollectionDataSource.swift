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
    var onSelect: IndexPathBlock?
    var onDelete: IndexPathBlock?
    var reorderable = false
    
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
    
    var items: [CollectionItem]
    
    var footerClass: UICollectionReusableView.Type?
    var configureFooter: ((UICollectionReusableView) -> ())?
    
    
    init<Header: UICollectionReusableView, Footer: UICollectionReusableView>(configureHeader: ((Header) -> ())? = nil, items: [CollectionItem], configureFooter: ((Footer) -> ())? = nil) {
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
    var sections: [CollectionSection]
    var onReorder: ReorderBlock?
    var onScroll: ScrollBlock?
    
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

extension BlockCollectionDataSource {
    @objc(registerReuseIdentifiersToCollectionView:)
    func registerReuseIdentifiers(to collectionView: UICollectionView) {
        for section in sections {
            if let headerViewClass = section.headerClass {
                let reuseIdentifier = String(describing: headerViewClass)
                if let _ = Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") {
                    let nib = UINib(nibName: reuseIdentifier, bundle: nil)
                    collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
                } else {
                    collectionView.register(headerViewClass, forCellWithReuseIdentifier: reuseIdentifier)
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
                    collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
                } else {
                    collectionView.register(footerViewClass, forCellWithReuseIdentifier: reuseIdentifier)
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
        let item = itemForIndexPath(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        guard onReorder != nil else { return false }
        return itemForIndexPath(indexPath).reorderable
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let reorder = onReorder {
            reorder(sourceIndexPath, destinationIndexPath)
            collectionView.reloadData()
        }
    }
}



// MARK: - Helpers

extension BlockCollectionDataSource {
    fileprivate func itemForIndexPath(_ indexPath: IndexPath) -> CollectionItem {
        let section = sections[indexPath.section]
        return section.items[indexPath.row]
    }
    
    fileprivate func sectionAtIndex(_ index: Int) -> CollectionSection? {
        guard sections.count > index else { return nil }
        return sections[index]
    }
}
