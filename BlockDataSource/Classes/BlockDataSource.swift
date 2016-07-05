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


public protocol RowInfo {
    var identifier: String { get set }
    var configure: ConfigBlock { get }
    var onSelect: ActionBlock? { get set }
    var onDelete: ActionBlock? { get set }
    var selectionStyle: UITableViewCellSelectionStyle { get set }
    var reorderable: Bool { get set }
}


public struct Row<T: UITableViewCell>: RowInfo {
    
    var configBlock: T -> Void
    public var configure: ConfigBlock {
        return configBlock as! ConfigBlock
    }
    
    public var identifier: String
    public var onSelect: ActionBlock?
    public var onDelete: ActionBlock?
    public var selectionStyle = UITableViewCellSelectionStyle.None
    public var reorderable = false
    
    public init(identifier: String, configBlock: T -> Void, onSelect: ActionBlock? = nil, onDelete: ActionBlock? = nil, selectionStyle: UITableViewCellSelectionStyle = .None, reorderable: Bool = true) {
        self.identifier = identifier
        self.configBlock = configBlock
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
    public var rows: [RowInfo]
    var footer: HeaderFooter?
    
    public init(header: HeaderFooter? = nil, rows: [RowInfo], footer: HeaderFooter? = nil) {
        self.header = header
        self.rows = rows
        self.footer = footer
    }
}


public class BlockDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    public var sections: [Section]
    var onReorder: ((firstIndex: Int, secondIndex: Int) -> Void)?
    var onScroll: ((scrollView: UIScrollView) -> Void)?
    
    init(sections: [Section] = [], onReorder: ((firstIndex: Int, secondIndex: Int) -> Void)? = nil, onScroll: ((scrollView: UIScrollView) -> Void)? = nil) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
    }
    
    func registerResuseIdentifiersToTableView(tableView: UITableView) {
        for section in sections {
            for row in section.rows {
                if (NSBundle.mainBundle().pathForResource(row.identifier, ofType: "nib") != nil) {
                    let nib = UINib(nibName: row.identifier, bundle: NSBundle.mainBundle())
                    tableView.registerNib(nib, forCellReuseIdentifier: row.identifier)
                }
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.count > 0 else {
            return 0
        }
        
        return sections[section].rows.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = rowForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(row.identifier, forIndexPath: indexPath) 
        cell.selectionStyle = row.selectionStyle
        row.configure(cell: cell)
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = rowForIndexPath(indexPath)
        if let onSelect = row.onSelect {
            onSelect(indexPath: indexPath)
        }
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sections.count > 0 else {
            return nil
        }
        
        return sections[section].header?.title
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard sections.count > 0 else {
            return nil
        }
        
        return sections[section].footer?.title
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections.count > 0 else {
            return 0.0
        }
        
        if let header = sections[section].header {
            return header.height
        } else {
            return 0.0
        }
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard sections.count > 0 else {
            return 0.0
        }
        
        if let footer = sections[section].footer {
            return footer.height
        } else {
            return 0
        }
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let row = rowForIndexPath(indexPath)
        return row.onDelete != nil
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
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if let onScroll = onScroll {
            onScroll(scrollView: scrollView)
        }
    }
    
    // MARK: - Helpers
    
    private func rowForIndexPath(indexPath: NSIndexPath) -> RowInfo {
        let section = sections[indexPath.section]
        return section.rows[indexPath.row]
    }
}
