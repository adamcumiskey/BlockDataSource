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
//  BlockTableDataSource.swift
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit


public typealias IndexPathBlock = (_ indexPath: IndexPath) -> Void
public typealias ReorderBlock = (_ sourceIndex: IndexPath, _ destinationIndex: IndexPath) -> Void
public typealias ScrollBlock = (_ scrollView: UIScrollView) -> Void

public protocol BlockConfigureable: class {
    var dataSource: BlockTableDataSource? { get set }
    func configureDataSource(dataSource: BlockTableDataSource)
}


// MARK: - TableRow

public struct TableRow {
    
    var cellClass: UITableViewCell.Type
    var reuseIdentifier: String { return String(describing: cellClass) }
    
    var configure: (UITableViewCell) -> ()
    var onSelect: IndexPathBlock?
    var onDelete: IndexPathBlock?
    var selectionStyle = UITableViewCellSelectionStyle.none
    var reorderable = false
    
    public init<Cell: UITableViewCell>(selectionStyle: UITableViewCellSelectionStyle = .none, reorderable: Bool = true, configure: @escaping (Cell) -> Void) {
        self.selectionStyle = selectionStyle
        self.reorderable = reorderable
        
        self.cellClass = Cell.self
        self.configure = { cell in
            configure(cell as! Cell)
        }
    }
    
    public init<Cell: UITableViewCell>(configure: @escaping (Cell) -> Void, onSelect: IndexPathBlock? = nil, onDelete: IndexPathBlock? = nil, selectionStyle: UITableViewCellSelectionStyle = .none, reorderable: Bool = true) {
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.selectionStyle = selectionStyle
        self.reorderable = reorderable
        
        self.cellClass = Cell.self
        self.configure = { cell in
            configure(cell as! Cell)
        }
    }
}


// MARK: - TableSection

public struct TableSection {
    
    public enum HeaderFooter {
        case label(String)
        case customView(UIView, height: CGFloat)
        
        var text: String? {
            switch self {
            case let .label(text):
                return text
            default:
                return nil
            }
        }
        
        var view: UIView? {
            switch self {
            case let .customView(view, _):
                return view
            default:
                return nil
            }
        }
    }
    
    var header: HeaderFooter?
    public var rows: [TableRow]
    var footer: HeaderFooter?
    
    public init(header: HeaderFooter? = nil, rows: [TableRow], footer: HeaderFooter? = nil) {
        self.header = header
        self.rows = rows
        self.footer = footer
    }
    
    public init(header: HeaderFooter? = nil, row: TableRow, footer: HeaderFooter? = nil) {
        self.header = header
        self.rows = [row]
        self.footer = footer
    }
}


// MARK: - BlockTableDataSource

open class BlockTableDataSource: NSObject {
    open var sections: [TableSection]
    open var onReorder: ReorderBlock?
    open var onScroll: ScrollBlock?
    
    public override init() {
        self.sections = [TableSection]()
        super.init()
    }
    
    public init(sections: [TableSection], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
    
    public init(section: TableSection, onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.sections = [section]
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
    
    public init(rows: [TableRow], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.sections = [TableSection(rows: rows)]
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
}


// MARK: - Reusable Registration

extension BlockTableDataSource {
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
}


// MARK: - UITableViewDataSource

extension BlockTableDataSource: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionAtIndex(section)?.rows.count ?? 0
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

extension BlockTableDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = rowForIndexPath(indexPath)
        if let onSelect = row.onSelect {
            onSelect(indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionAtIndex(section)?.header?.text
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionAtIndex(section)?.header?.view
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sectionAtIndex(section)?.footer?.text
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sectionAtIndex(section)?.footer?.view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = sectionAtIndex(section)?.header else { return UITableViewAutomaticDimension }
        switch header {
        case let .label(_):
            return UITableViewAutomaticDimension
        case let .customView(_, height):
            return height
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footer = sectionAtIndex(section)?.footer else { return UITableViewAutomaticDimension }
        switch footer {
        case let .label(_):
            return UITableViewAutomaticDimension
        case let .customView(_, height):
            return height
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
            tableView.reloadData()
        }
    }
}


//// MARK: - UICollectionViewDataSource
//
//extension BlockTableDataSource: UICollectionViewDataSource {
//    public func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return sections.count
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return sections[section].rows.count
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let row = rowForIndexPath(indexPath)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.reuseIdentifier, for: indexPath)
//        row.configure(cell)
//        return cell
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let section = sections[indexPath.section]
//        if kind == UICollectionElementKindSectionHeader {
//            if let header = section.header, let headerViewClass = header.reusableViewClass {
//                let view = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: headerViewClass), for: indexPath)
//                header.configure?(view)
//                return view
//            }
//        } else if kind == UICollectionElementKindSectionFooter {
//            if let footer = section.footer, let footerViewClass = footer.reusableViewClass {
//                let view = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: footerViewClass), for: indexPath)
//                footer.configure?(view)
//                return view
//            }
//        }
//        return UICollectionReusableView()
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return rowForIndexPath(indexPath).reorderable
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        if let reorder = onReorder {
//            reorder(sourceIndexPath, destinationIndexPath)
//        }
//    }
//}
//
//
//// MARK: - UICollectionViewDelegate
//
//extension BlockTableDataSource: UICollectionViewDelegate {
//    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return rowForIndexPath(indexPath).onSelect != nil
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let onSelect = rowForIndexPath(indexPath).onSelect {
//            onSelect(indexPath)
//        }
//    }
//}


// MARK: - UIScrollViewDelegate

extension BlockTableDataSource {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let onScroll = onScroll {
            onScroll(scrollView)
        }
    }
}


// MARK: - Helpers

extension BlockTableDataSource {
    fileprivate func rowForIndexPath(_ indexPath: IndexPath) -> TableRow {
        let section = sections[indexPath.section]
        return section.rows[indexPath.row]
    }
    
    fileprivate func sectionAtIndex(_ index: Int) -> TableSection? {
        guard sections.count > index else { return nil }
        return sections[index]
    }
}
