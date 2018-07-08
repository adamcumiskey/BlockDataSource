//
//  CellTypesTableViewController.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BlockDataSource
import UIKit

let cellTypesViewController = BlockTableViewController(
    style: .grouped,
    dataSource: DataSource(
        items: [
            Item { (cell: BedazzledTableViewCell) in
                cell.titleLabel.text = "Custom cells"
            },
            Item { (cell: SubtitleTableViewCell) in
                cell.textLabel?.text = "Load any cell with ease"
                cell.detailTextLabel?.text = "BlockDataSource automatically registers and loads the correct cell by using the class specified in the configure block."
                cell.detailTextLabel?.numberOfLines = 0
            }
        ],
        middleware: Middleware(
            tableViewCellMiddleware: [
                TableViewCellMiddleware.noCellSelectionStyle
            ]
        )
    )
)
