//
//  MiddlewareViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 2/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import BlockDataSource

class MiddlewareViewController: UIViewController, ConfigurableTable, Table {
    @IBOutlet weak var table: UITableView!
    var dataSource: List?
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMarginConstraint: NSLayoutConstraint!
    var margin: CGFloat = 0.0 {
        didSet {
            leftMarginConstraint.constant = margin
            rightMarginConstraint.constant = margin
        }
    }
    
    var data = ["a", "b", "c", "d", "e", "f"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        margin = 10
        view.backgroundColor = table.backgroundColor
        table.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        table.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataAndUI()
    }
    
    func configureDataSource(dataSource: List) {
        dataSource.middlewareStack = [
            Middleware { (cell: RoundCorneredCell, path, structure) in
                cell.cornerRadius = 5.0
                if path.row == 0 {
                    cell.position = .top
                } else if path.row == structure[path.section].rows.count-1 {
                    cell.position = .bottom
                }
            }
        ]
        dataSource.sections = [
            List.Section(
                rows: data.map { n in
                    return List.Row { (cell: RoundCorneredCell) in
                        cell.textLabel?.text = "\(n)"
                    }
                }
            )
        ]
    }
    
}