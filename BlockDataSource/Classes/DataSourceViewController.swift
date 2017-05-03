//
//  DataSourceViewController.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import Foundation


public protocol DataSourceReloadable {
    associatedtype DataSource: DataSourceProtocol
    var dataSource: DataSource { get set }
    func reload()
}

public class DataSourceViewController<DataSource: DataSourceProtocol>: UIViewController {
    var dataSource: DataSource
    init(dataSource: DataSource, nibName: String? = nil, bundle: Bundle? = nil) {
        self.dataSource = dataSource
        super.init(nibName: nibName, bundle: bundle)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



open class DataSourceTableViewController: UITableViewController, DataSourceReloadable {
    public var dataSource: ListDataSource {
        didSet { reload() }
    }

    public init() {
        self.dataSource = ListDataSource()
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    public func reload() {
        guard let tableView = tableView else { return }

        let dataSource = ListDataSource()

        tableView.registerReuseIdentifiers(forDataSource: dataSource)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource

        self.dataSource = dataSource
        tableView.reloadData()
    }
}


open class DataSourceCollectionViewController: UICollectionViewController, DataSourceReloadable {
    public var dataSource: GridDataSource

    public init() {
        self.dataSource = GridDataSource()
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    public func reload() {
        guard let collectionView = collectionView else { return }

        let dataSource = GridDataSource()

        collectionView.registerReuseIdentifiers(forDataSource: dataSource)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource

        self.dataSource = dataSource
        collectionView.reloadData()
    }
}

