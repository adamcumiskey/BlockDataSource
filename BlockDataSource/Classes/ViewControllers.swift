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

/// Conforming to this protocol provides useful methods for connecting a DataSource to a UITableView
public protocol TableViewReloadable: DataSourceProvidable {
    /// Reference to the UITableView
    var tableView: UITableView! { get }
}

public extension TableViewReloadable {
    /// Reloads the tableView with the current dataSource
    func reload() {
        guard let dataSource = dataSource else { return }
        tableView.registerReuseIdentifiers(forDataSource: dataSource)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.reloadData()
    }
}

/// UITableViewController subclass powered by a DataSource
open class BlockTableViewController: UITableViewController, TableViewReloadable {
    public var dataSource: DataSource? {
        didSet {
            reload()
        }
    }
    
    public override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    public init(style: UITableViewStyle, dataSource: DataSource?) {
        self.dataSource = dataSource
        super.init(style: style)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }
}

// MARK: - Collection View Controller

/// Conforming to this protocol provides useful methods for connecting a DataSource to a UICollectionView
public protocol CollectionViewReloadable: DataSourceProvidable {
    /// Reference to the UICollectionView
    var collectionView: UICollectionView? { get }
}

public extension CollectionViewReloadable {
    /// Reloads the collection view with the current dataSource
    func reload() {
        guard let collectionView = collectionView, let dataSource = dataSource else { return }
        collectionView.registerReuseIdentifiers(forDataSource: dataSource)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        collectionView.reloadData()
    }
}

/// UICollectionViewController subclass powered by a DataSource
open class BlockCollectionViewController: UICollectionViewController, CollectionViewReloadable {
    public var dataSource: DataSource? {
        didSet {
            reload()
        }
    }
    
    public override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    public init(collectionViewLayout layout: UICollectionViewLayout, dataSource: DataSource?) {
        self.dataSource = dataSource
        super.init(collectionViewLayout: layout)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }
}
