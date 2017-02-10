//
//  MiddlewareViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 2/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import BlockDataSource

class MiddlewareViewController: BlockTableViewController {
    override func configureDataSource(dataSource: List) {
        super.configureDataSource(dataSource: dataSource)
        dataSource.middlewareStack = [
            Middleware { (cell: RoundCorneredCell, path, structure) in
                if path.row == 0 {
                    cell.position = .top
                } else if path.row == structure[path.section].rows.count-1 {
                    cell.position = .bottom
                }
            }
        ]
        dataSource.sections = [
            List.Section(
                rows: ["a", "b", "c", "d", "e", "f"].map { n in
                    return List.Row { (cell: RoundCorneredCell) in
                        cell.textLabel?.text = "\(n)"
                    }
                }
            )
        ]
    }
}
