//
//  CellTypesTableViewController.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BlockDataSource
import UIKit

class CellTypesTableViewController: BlockTableViewController {
    init() {
        super.init(style: .grouped)
        self.title = "Cell Types"
        self.dataSource = DataSource(
            sections: [
                Section(
                    items: [
                        Item { (cell: BedazzledTableViewCell) in
                            cell.titleLabel.text = "Custom cells"
                        },
                        Item { (cell: SubtitleTableViewCell) in
                            cell.textLabel?.text = "Load any cell with ease"
                            cell.detailTextLabel?.text = "BlockDataSource automatically registers and loads the correct cell by using the class specified in the configure block."
                            cell.detailTextLabel?.numberOfLines = 0
                        }
                    ]
                )
            ],
            middleware: [
                Middleware.noCellSelectionStyle,
                Middleware.separatorInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            ]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
