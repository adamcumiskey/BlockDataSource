//
//  ListViewController.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var dataSource: ListDataSource {
        didSet { reload() }
    }

    init(dataSource: ListDataSource) {
        self.dataSource = dataSource
        super.init(nibName: "ListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    func reload() {
        guard let tableView = tableView else { return }
        tableView.registerReuseIdentifiers(forDataSource: dataSource)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.reloadData()
    }
}
