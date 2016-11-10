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
//  bestroute
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit


public typealias ConfigBlock = (cell: UITableViewCell) -> Void
public typealias ActionBlock = (indexPath: NSIndexPath) -> Void
public typealias ReorderBlock = (firstIndex: Int, secondIndex: Int) -> Void
public typealias ScrollBlock = (scrollView: UIScrollView) -> Void

public struct Row {
    
    var cellClass: AnyClass
    var reuseIdentifier: String {
        return String(cellClass)
    }
    
    var configure: ConfigBlock
    var onSelect: ActionBlock?
    var onDelete: ActionBlock?
    var selectionStyle = UITableViewCellSelectionStyle.None
    var reorderable = false
    
    public init(cellClass: AnyClass = UITableViewCell.self, configure: ConfigBlock, onSelect: ActionBlock? = nil, onDelete: ActionBlock? = nil, selectionStyle: UITableViewCellSelectionStyle = .None, reorderable: Bool = true) {
        self.cellClass = cellClass
        self.configure = configure
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.selectionStyle = selectionStyle
        self.reorderable = reorderable
    }
}


public struct Section {
    
    public struct HeaderFooter {
        var title: String?
        var height: CGFloat
        
        public init(title: String? = nil, height: CGFloat) {
            self.title = title
            self.height = height
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


public class BlockDataSource: NSObject {
    
    public var sections: [Section]
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
    
    func registerResuseIdentifiers(to tableView: UITableView) {
        for section in sections {
            for row in section.rows {
                if (NSBundle.mainBundle().pathForResource(row.reuseIdentifier, ofType: "nib") != nil) {
                    let nib = UINib(nibName: row.reuseIdentifier, bundle: NSBundle.mainBundle())
                    tableView.registerNib(nib, forCellReuseIdentifier: row.reuseIdentifier)
                } else {
                    tableView.registerClass(row.cellClass, forCellReuseIdentifier: row.reuseIdentifier)
                }
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if let onScroll = onScroll {
            onScroll(scrollView: scrollView)
        }
    }
    
    // MARK: - Helpers
    
    private func rowForIndexPath(indexPath: NSIndexPath) -> Row {
        let section = sections[indexPath.section]
        return section.rows[indexPath.row]
    }
}


//MARK: - UITableViewDataSource

extension BlockDataSource: UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.count > 0 else { return 0 }
        return sections[section].rows.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = rowForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(row.reuseIdentifier, forIndexPath: indexPath)
        cell.selectionStyle = row.selectionStyle
        row.configure(cell: cell)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension BlockDataSource: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = rowForIndexPath(indexPath)
        if let onSelect = row.onSelect {
            onSelect(indexPath: indexPath)
        }
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sections.count > 0 else { return nil }
        return sections[section].header?.title
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard sections.count > 0 else { return nil }
        return sections[section].footer?.title
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections.count > 0 else { return UITableViewAutomaticDimension }
        guard let header = sections[section].header else { return UITableViewAutomaticDimension }
        return header.height
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard sections.count > 0 else { return UITableViewAutomaticDimension }
        guard let footer = sections[section].footer else { return UITableViewAutomaticDimension }
        return footer.height
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let row = rowForIndexPath(indexPath)
        return row.onDelete != nil || row.reorderable == true
    }
    
    public func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let row = rowForIndexPath(indexPath)
        guard let _ = row.onDelete else { return .None }
        return .Delete
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let row = rowForIndexPath(indexPath)
            if let onDelete = row.onDelete {
                onDelete(indexPath: indexPath)
                sections[indexPath.section].rows.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let row = rowForIndexPath(indexPath)
        return row.reorderable
    }
    
    public func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        let destination = rowForIndexPath(proposedDestinationIndexPath)
        if destination.reorderable {
            return proposedDestinationIndexPath
        } else {
            return sourceIndexPath
        }
    }
    
    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if let reorder = onReorder {
            reorder(firstIndex: sourceIndexPath.row, secondIndex: destinationIndexPath.row)
        }
    }
}
