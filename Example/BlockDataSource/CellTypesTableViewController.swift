//
//  CellTypesTableViewController.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BlockDataSource
import UIKit

let cellTypesViewController: UIViewController = {
    let vc = BlockTableViewController(
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
            middleware: [
                Middleware.noCellSelectionStyle,
                Middleware.separatorInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            ]
        )
    )
    vc.title = "Cell Types"
    return vc
}()
