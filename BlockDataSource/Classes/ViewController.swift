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

public protocol ReloadableTableView: DataSourceProvidable {
    var tableView: UITableView! { get }
    func reload()
}

public protocol ConfigurableTableView: ReloadableTableView {
    func configure(dataSource: DataSource)
}

public extension ReloadableTableView {
    func reload() {
        guard let tableView = tableView else { return }
        tableView.registerReuseIdentifiers(forDataSource: dataSource)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.reloadData()
    }
}

public extension ConfigurableTableView {
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

open class TableViewController: UITableViewController, ReloadableTableView {
    public var dataSource: DataSource {
        didSet { reload() }
    }

    init(dataSource: DataSource, style: UITableViewStyle = .plain) {
        self.dataSource = dataSource
        super.init(style: style)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
}

// MARK: - Collection View Controller

public protocol ReloadableCollectionView: DataSourceProvidable {
    var collectionView: UICollectionView? { get }
    func reload()
}

public protocol ConfigurableCollectionView: ReloadableCollectionView {
    func configure(dataSource: DataSource)
}

public extension ReloadableCollectionView {
    func reload() {
        guard let collectionView = collectionView else { return }
        collectionView.registerReuseIdentifiers(forDataSource: dataSource)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        collectionView.reloadData()
    }
}

public extension ConfigurableCollectionView {
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

open class CollectionViewController: UICollectionViewController, ReloadableCollectionView {
    public var dataSource: DataSource {
        didSet { reload() }
    }

    init(dataSource: DataSource, collectionViewLayout: UICollectionViewLayout) {
        self.dataSource = dataSource
        super.init(collectionViewLayout: collectionViewLayout)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
}
