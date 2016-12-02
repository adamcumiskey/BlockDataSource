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
//  BlockTableViewController.swift
//
//  Created by Adam Cumiskey on 6/17/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit


extension BlockConfigureable where Self: UITableViewController {
    public func reloadUI(animated: Bool = false) {
        guard let tableView = tableView else { return }
        
        let dataSource = BlockDataSource()
        configureDataSource(dataSource: dataSource)
        
        dataSource.registerReuseIdentifiers(to: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        if animated == false || self.dataSource == nil {
            tableView.reloadData()
        } else {
            var removed = [IndexPath]()
            var added = [IndexPath]()
            
            for (index, section) in self.dataSource!.sections.enumerated() {
                guard dataSource.sections.count > index else { continue }
                let sectionIDs = section.rows.map { $0.rowID }
                let newSectionIDs = dataSource.sections[index].rows.map { $0.rowID }
                
                let diff = getDiff(sectionIDs, newSectionIDs)
                
                let removedIndexes = diff.removed.map { IndexPath(row: sectionIDs.index(of: $0)!, section: index) }
                removed.append(contentsOf: removedIndexes)
                
                let addedIndexes = diff.added.map { IndexPath(row: newSectionIDs.index(of: $0)!, section: index) }
                added.append(contentsOf: addedIndexes)
            }
            
            print("added: \(added)")
            print("removed: \(removed)")
            tableView.beginUpdates()
            tableView.deleteRows(at: removed, with: .fade)
            tableView.insertRows(at: added, with: .fade)
            tableView.endUpdates()
        }
        
        self.dataSource = dataSource
    }
}


open class BlockTableViewController: UITableViewController, BlockConfigureable {
    open var dataSource: BlockDataSource?
    
    open func configureDataSource(dataSource: BlockDataSource) {
        // Base class does nothing
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.separatorInset = .zero
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadUI()
    }
}
