//
//  DataSource.swift
//  bestroute
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit

class BlockDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var sections: [Section]
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.count > 0 else {
            return 0
        }
        
        return sections[section].rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = rowForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(row.identifier, forIndexPath: indexPath) 
        cell.selectionStyle = row.selectionStyle
        row.configure(cell: cell)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = rowForIndexPath(indexPath)
        if let onSelect = row.onSelect {
            onSelect(indexPath: indexPath)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sections.count > 0 else {
            return nil
        }
        
        return sections[section].header.title
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard sections.count > 0 else {
            return nil
        }
        
        return sections[section].footer.title
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections.count > 0 else {
            return 0.0
        }
        
        if self.tableView(tableView, titleForHeaderInSection: section) != nil {
            return sections[section].header.height
        } else {
            return 0.0
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard sections.count > 0 else {
            return 0.0
        }
        
        if self.tableView(tableView, titleForFooterInSection: section) != nil {
            return sections[section].footer.height
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let row = rowForIndexPath(indexPath)
        return row.onDelete != nil
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let row = rowForIndexPath(indexPath)
            if let onDelete = row.onDelete {
                onDelete(indexPath: indexPath)
                sections[indexPath.section].rows.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let row = rowForIndexPath(indexPath)
        return row.reorderable
    }
    
    func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        let destination = rowForIndexPath(proposedDestinationIndexPath)
        if destination.reorderable {
            return proposedDestinationIndexPath
        } else {
            return sourceIndexPath
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if let reorder = onReorder {
            reorder(firstIndex: sourceIndexPath.row, secondIndex: destinationIndexPath.row)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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
