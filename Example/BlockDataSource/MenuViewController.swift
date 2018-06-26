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
                            cell.textLabel?.text = "Cell Types"
                        }, onSelect: { [unowned self] _ in
                            self.navigationController?.pushViewController(CellTypesTableViewController(), animated: true)
                        }),
                        Item(configure: { (cell: UITableViewCell) in
                            cell.textLabel?.text = "Middleware"
                        }, onSelect: { [unowned self] _ in
                            self.navigationController?.pushViewController(MiddlwareViewController(), animated: true)
                        })
                    ]
                ),
                Section(
                    title: "Collection Views",
                    items: [
                        Item(configure: { (cell: UITableViewCell) in
                            cell.textLabel?.text = "Reordering"
                        }, onSelect: { [unowned self] _ in
                            self.navigationController?.pushViewController(ExampleCollectionViewController(), animated: true)
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
