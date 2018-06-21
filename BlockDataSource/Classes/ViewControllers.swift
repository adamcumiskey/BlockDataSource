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
//  ViewControllers.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.


import Foundation

public protocol DataSourceProvidable: class {
    var dataSource: DataSource? { get set }
}

// MARK: - Table View Controller

public protocol TableViewReloadable: DataSourceProvidable {
    var tableView: UITableView! { get }
}

public extension TableViewReloadable {
    func reload() {
        guard let tableView = tableView, let dataSource = dataSource else { return }
        tableView.registerReuseIdentifiers(forDataSource: dataSource)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.reloadData()
    }
}

open class BlockTableViewController: UITableViewController, TableViewReloadable {
    public var dataSource: DataSource? {
        didSet {
            reload()
        }
    }
    
    public override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    public convenience init(style: UITableViewStyle, dataSource: DataSource) {
        self.init(style: style)
        self.dataSource = dataSource
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if let tableView = tableView {
            dataSource?.middleware.forEach { $0.apply(tableView, IndexPath(item: -1, section: -1), []) }
        }
        reload()
    }
}

// MARK: - Collection View Controller

public protocol CollectionViewReloadable: DataSourceProvidable {
    var collectionView: UICollectionView? { get }
}

public extension CollectionViewReloadable {
    func reload() {
        guard let collectionView = collectionView, let dataSource = dataSource else { return }
        collectionView.registerReuseIdentifiers(forDataSource: dataSource)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        collectionView.reloadData()
    }
}

open class BlockCollectionViewController: UICollectionViewController, CollectionViewReloadable {
    public var dataSource: DataSource? {
        didSet {
            reload()
        }
    }
    
    public override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    public convenience init(collectionViewLayout layout: UICollectionViewLayout, dataSource: DataSource) {
        self.init(collectionViewLayout: layout)
        self.dataSource = dataSource
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if let collectionView = collectionView {
            dataSource?.middleware.forEach { $0.apply(collectionView, IndexPath(item: -1, section: -1), []) }
        }
        reload()
    }
}
