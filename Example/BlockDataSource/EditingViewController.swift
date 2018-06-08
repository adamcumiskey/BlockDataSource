//
//  EditingViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 11/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import BlockDataSource


class EditingViewController: ConfigureableTableViewController {
    var data: [String] = (0..<5).map { "\($0)" }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
    }

    override func configure(dataSource: DataSource) {
        dataSource.sections = [
            Section(
                items: data.map { dataItem in
                    return Item(
                        onDelete: { [unowned self] indexPath in
                            if let index = self.data.index(of: dataItem) {
                                self.data.remove(at: index)
                            }
                        },
                        reorderable: true,
                        configure: { (cell: Cell) in
                            cell.textLabel?.text = dataItem
                        }
                    )
                }
            )
        ]
        dataSource.onReorder = { [unowned self] (firstIndex, secondIndex) in
            self.data.moveObjectAtIndex(firstIndex.row, toIndex: secondIndex.row)
        }
    }
}
