//
//  MiddlewareViewController.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BlockDataSource
import UIKit

class MiddlewareViewController: BlockTableViewController {
    init() {
        super.init(style: .plain)
        self.title = "Middleware"
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.dataSource = DataSource(
            sections: [
                Section(
                    header: Reusable { (view: InformationHeaderFooterView) in
                        view.titleLabel.text = "Middleware is applied to each cell before it is displayed."
                    },
                    items: (0..<50).map { item in
                        return Item { (cell: UITableViewCell) in
                            cell.textLabel?.text = "\(item)"
                        }
                    }
                )
            ],
            middleware: DataSource.MiddlewareConfig(
                tableViewCellMiddleware: [
                    TableViewCellMiddleware.noCellSelectionStyle,
                    TableViewCellMiddleware.cellGradient
                ],
                tableViewMiddleware: [
                    TableViewMiddleware.noTableSeparator
                ]
            )
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
