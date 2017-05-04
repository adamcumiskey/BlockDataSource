//
//  DataSourceViewController.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import Foundation


public protocol DataSourceProvidable: class {
    var dataSource: DataSource { get set }
}


// MARK: - Table View Controller

public protocol TableViewReloadable: DataSourceProvidable {
    var tableView: UITableView! { get }
}

public extension TableViewReloadable {
    func reload() {
        guard let tableView = tableView else { return }
        tableView.registerReuseIdentifiers(forDataSource: dataSource)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.reloadData()
    }
}

public protocol TableViewConfigurable: DataSourceProvidable {
    var tableView: UITableView! { get }
    func configure(dataSource: DataSource)
}

public extension TableViewConfigurable {
    func reload() {
        guard let tableView = tableView else { return }
        let dataSource = DataSource()
        configure(dataSource: dataSource)
        tableView.registerReuseIdentifiers(forDataSource: dataSource)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        self.dataSource = dataSource
        tableView.reloadData()
    }
}

open class BlockTableViewController: UITableViewController, TableViewConfigurable {
    public var dataSource: DataSource = DataSource()

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    open func configure(dataSource: DataSource) {
        // Subclass
    }
}


// MARK: - Collection View Controller

public protocol CollectionViewReloadable: DataSourceProvidable {
    var collectionView: UICollectionView? { get }
}

public extension CollectionViewReloadable {
    func reload() {
        guard let collectionView = collectionView else { return }
        collectionView.registerReuseIdentifiers(forDataSource: dataSource)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        collectionView.reloadData()
    }
}

public protocol CollectionViewConfigurable: DataSourceProvidable {
    var collectionView: UICollectionView? { get }
    func configure(dataSource: DataSource)
}

public extension CollectionViewConfigurable {
    func reload() {
        guard let collectionView = collectionView else { return }
        let dataSource = DataSource()
        configure(dataSource: dataSource)
        collectionView.registerReuseIdentifiers(forDataSource: dataSource)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        self.dataSource = dataSource
        collectionView.reloadData()
    }
}

open class BlockCollectionViewController: UICollectionViewController, CollectionViewConfigurable {
    public var dataSource: DataSource = DataSource()

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    open func configure(dataSource: DataSource) {
        // Subclass
    }
}
