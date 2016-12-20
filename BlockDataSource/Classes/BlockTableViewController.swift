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


public protocol ConfigurableTable: class {
    var dataSource: List? { get set }
    func configureDataSource(dataSource: List)
}


public extension ConfigurableTable where Self: UITableViewController {
    public func createDataSource() {
        guard let tableView = tableView else { return }
        
        let dataSource = List()
        configureDataSource(dataSource: dataSource)
        
        dataSource.registerReuseIdentifiers(to: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        self.dataSource = dataSource
    }
    
    public func reloadDataAndUI() {
        createDataSource()
        tableView.reloadData()
    }
}


open class BlockTableViewController: UITableViewController, ConfigurableTable {
    public var dataSource: List?
    
    open func configureDataSource(dataSource: List) {
        // Base class does nothing
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataAndUI()
    }
}
