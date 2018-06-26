//
//  MiddlewareViewController.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BlockDataSource
import UIKit

class MenuViewController: BlockTableViewController {
    init() {
        super.init(style: .grouped)
        self.title = "Demo"
        self.dataSource = DataSource(
            sections: [
                Section(
                    title: "Table Views",
                    items: [
                        Item(configure: { (cell: UITableViewCell) in
                            cell.textLabel?.text = "Editing"
                        }, onSelect: { [unowned self] _ in
                            self.navigationController?.pushViewController(EditingViewController(), animated: true)
                        }),
                        Item(configure: { (cell: UITableViewCell) in
                            cell.textLabel?.text = "Middleware"
                        }, onSelect: { [unowned self] _ in
                            self.navigationController?.pushViewController(MiddlwareViewController(), animated: true)
                        })
                    ]
                )
            ],
            middleware: [
                Middleware.disclosureIndicators
            ]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EditingViewController: BlockTableViewController {
    var items = (0..<100).map { $0 }
    
    init() {
        super.init(style: .plain)
        self.title = "Editing"
        self.navigationItem.rightBarButtonItem = editButtonItem
        self.dataSource = DataSource(
            sections: [
                Section(
                    items: items.map { item in
                        return Item(configure: { (cell: UITableViewCell) in
                            cell.textLabel?.text = "\(item)"
                        }, onDelete: { [unowned self] indexPath in
                            self.items.remove(at: indexPath.row)
                        }, reorderable: true)
                    }
                )
            ],
            onReorder: { [unowned self] origin, destination in
                self.items.moveObjectAtIndex(origin.row, toIndex: destination.row)
            },
            middleware: [
                Middleware.noCellSelectionStyle
            ]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MiddlwareViewController: BlockTableViewController {
    init() {
        super.init(style: .plain)
        self.title = "Middleware"
        self.dataSource = DataSource(
            sections: [
                Section(
                    items: (0..<50).map { _ in
                        return Item { (cell: UITableViewCell) in
                            cell.textLabel?.text = "Hi"
                        }
                    }
                )
            ],
            middleware: [
                Middleware.noCellSelectionStyle,
                Middleware.cellGradient,
                Middleware.noTableSeparator
            ]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
