//
//  BlockTableViewController.swift
//  bestroute
//
//  Created by Adam Cumiskey on 6/17/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit

public protocol BlockConfigurableDataSource {
    func reloadUI()
    func configure(datasource: BlockDataSource)
}

public class BlockTableViewController: UITableViewController, BlockConfigurableDataSource {
    
    private var dataSource: BlockDataSource?
    
    override init(style: UITableViewStyle = .Grouped) {
        super.init(style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
        self.tableView.separatorInset = UIEdgeInsetsZero
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUI()
    }
    
    public func reloadUI() {
        let dataSource = BlockDataSource()
        configure(dataSource)
        dataSource.registerResuseIdentifiersToTableView(self.tableView)
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        self.dataSource = dataSource
        self.tableView.reloadData()
    }

    public func configure(datasource: BlockDataSource) {
        fatalError("This method must be subclassed")
    }
}
