//
//  EditingViewController.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BlockDataSource
import UIKit

class EditingViewController: BlockTableViewController {
    var items = (0..<100).map { $0 }
    
    init() {
        super.init(style: .plain)
        
        self.title = "Editing"
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.dataSource = DataSource(
            sections: [
                Section(
                    header: Reusable { (view: InformationHeaderFooterView) in
                        view.titleLabel.text = "Tap \"Edit\" to enabled deletion and reordering. Tap \"Done\" to end editing."
                    },
                    items: items.map { item in
                        return Item(
                            configure: { (cell: UITableViewCell) in
                                cell.textLabel?.text = "\(item)"
                            },
                            onDelete: { [unowned self] indexPath in
                                self.items.remove(at: indexPath.row)
                            },
                            reorderable: true
                        )
                    }
                )
            ],
            onReorder: { [unowned self] origin, destination in
                self.items.moveObjectAtIndex(origin.row, toIndex: destination.row)
            },
            middleware: DataSource.MiddlewareConfig(
                tableViewCellMiddleware: [
                    TableViewCellMiddleware.noCellSelectionStyle
                ]
            )
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

