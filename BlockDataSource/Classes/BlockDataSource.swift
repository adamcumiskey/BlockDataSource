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
//  BlockDataSource.swift
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit


public typealias ConfigBlock = (AnyObject) -> Void
public typealias IndexPathBlock = (_ indexPath: IndexPath) -> Void
public typealias ReorderBlock = (_ sourceIndex: IndexPath, _ destinationIndex: IndexPath) -> Void
public typealias ScrollBlock = (_ scrollView: UIScrollView) -> Void

public protocol BlockConfigureable {
    var dataSource: BlockDataSource? { get set }
}


// MARK: - Row

public struct Row {
    
    var cellClass: AnyClass
    var reuseIdentifier: String {
        return String(describing: cellClass)
    }
    
    var configure: ConfigBlock
    var onSelect: IndexPathBlock?
    var onDelete: IndexPathBlock?
    var selectionStyle = UITableViewCellSelectionStyle.none
    var reorderable = false
    
    public init(cellClass: AnyClass = UITableViewCell.self, configure: @escaping ConfigBlock, onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, selectionStyle: UITableViewCellSelectionStyle = .none, reorderable: Bool = true) {
        self.cellClass = cellClass
        self.configure = configure
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.selectionStyle = selectionStyle
        self.reorderable = reorderable
    }
}


// MARK: - Section

public struct Section {
    
    public struct HeaderFooter {
        // Title/Height for basic tableview headers/footers
        var title: String?
        var height: CGFloat?
        public init(title: String, height: CGFloat = 30) {
            self.title = title
            self.height = height
        }
        
        // Custom view for tableview headers/footers
        var view: UIView?
        public init(view: UIView) {
            self.view = view
        }
        
        // Reusable view for collection view
        var reusableViewClass: AnyClass?
        var configure: ConfigBlock?
        public init(reusableViewClass: AnyClass, configure: @escaping ConfigBlock) {
            self.reusableViewClass = reusableViewClass
            self.configure = configure
        }
    }
    
    var header: HeaderFooter?
    public var rows: [Row]
    var footer: HeaderFooter?
    
    public init(header: HeaderFooter? = nil, rows: [Row], footer: HeaderFooter? = nil) {
        self.header = header
        self.rows = rows
        self.footer = footer
    }
    
    public init(header: HeaderFooter? = nil, row: Row, footer: HeaderFooter? = nil) {
        self.header = header
        self.rows = [row]
        self.footer = footer
    }
}


// MARK: - BlockDataSource

open class BlockDataSource: NSObject {
    open var sections: [Section]
    var onReorder: ReorderBlock?
    var onScroll: ScrollBlock?
    
    public init(sections: [Section], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
    
    public init(section: Section, onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.sections = [section]
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
    
    public init(rows: [Row], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.sections = [Section(rows: rows)]
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
}


// MARK: - Reusable Registration

extension BlockDataSource {
    @objc(registerReuseIdentifiersToTableView:)
    func registerReuseIdentifiers(to tableView: UITableView) {
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
    
    @objc(registerReuseIdentifiersToCollectionView:)
    func registerReuseIdentifiers(to collectionView: UICollectionView) {
        for section in sections {
            if let header = section.header, let headerViewClass = header.reusableViewClass {
                let reuseIdentifier = String(describing: headerViewClass)
                if let _ = Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") {
                    let nib = UINib(nibName: reuseIdentifier, bundle: nil)
                    collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
                } else {
                    collectionView.register(headerViewClass, forCellWithReuseIdentifier: reuseIdentifier)
                }
            }
            for row in section.rows {
                if let _ = Bundle.main.path(forResource: row.reuseIdentifier, ofType: "nib") {
                    let nib = UINib(nibName: row.reuseIdentifier, bundle: Bundle.main)
                    collectionView.register(nib, forCellWithReuseIdentifier: row.reuseIdentifier)
                } else {
                    collectionView.register(row.cellClass, forCellWithReuseIdentifier: row.reuseIdentifier)
                }
            }
            if let footer = section.footer, let footerViewClass = footer.reusableViewClass {
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


//MARK: - UITableViewDataSource

extension BlockDataSource: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rowForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        cell.selectionStyle = row.selectionStyle
        row.configure(cell)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension BlockDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = rowForIndexPath(indexPath)
        if let onSelect = row.onSelect {
            onSelect(indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header?.title
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = sections[section].header, let headerView = header.view else { return nil }
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer?.title
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = sections[section].header, let footerView = footer.view else { return nil }
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = sections[section].header else { return 0.0 }
        if let view = header.view {
            return UITableViewAutomaticDimension
        } else if let height = header.height {
            return height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footer = sections[section].footer else { return 0.0 }
        if let view = footer.view {
            return UITableViewAutomaticDimension
        } else if let height = footer.height {
            return height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = rowForIndexPath(indexPath)
        return row.onDelete != nil || row.reorderable == true
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let row = rowForIndexPath(indexPath)
        guard let _ = row.onDelete else { return .none }
        return .delete
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = rowForIndexPath(indexPath)
            if let onDelete = row.onDelete {
                onDelete(indexPath)
                sections[indexPath.section].rows.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let row = rowForIndexPath(indexPath)
        return row.reorderable
    }
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let destination = rowForIndexPath(proposedDestinationIndexPath)
        if destination.reorderable {
            return proposedDestinationIndexPath
        } else {
            return sourceIndexPath
        }
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let reorder = onReorder {
            reorder(sourceIndexPath, destinationIndexPath)
        }
    }
}


// MARK: - UICollectionViewDataSource

extension BlockDataSource: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = rowForIndexPath(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.reuseIdentifier, for: indexPath)
        row.configure(cell)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        if kind == UICollectionElementKindSectionHeader {
            if let header = section.header, let headerViewClass = header.reusableViewClass {
                let view = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: headerViewClass), for: indexPath)
                header.configure?(view)
                return view
            }
        } else if kind == UICollectionElementKindSectionFooter {
            if let footer = section.footer, let footerViewClass = footer.reusableViewClass {
                let view = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: footerViewClass), for: indexPath)
                footer.configure?(view)
                return view
            }
        }
        return UICollectionReusableView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return rowForIndexPath(indexPath).reorderable
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let reorder = onReorder {
            reorder(sourceIndexPath, destinationIndexPath)
        }
    }
}


// MARK: - UICollectionViewDelegate

extension BlockDataSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return rowForIndexPath(indexPath).onSelect != nil
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let onSelect = rowForIndexPath(indexPath).onSelect {
            onSelect(indexPath)
        }
    }
}


// MARK: - UIScrollViewDelegate

extension BlockDataSource {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let onScroll = onScroll {
            onScroll(scrollView)
        }
    }
}


// MARK: - Helpers

extension BlockDataSource {
    fileprivate func rowForIndexPath(_ indexPath: IndexPath) -> Row {
        let section = sections[indexPath.section]
        return section.rows[indexPath.row]
    }
}
