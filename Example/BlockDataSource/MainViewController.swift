//
//  MainViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 11/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import BlockDataSource


class MainViewController: BlockTableViewController {
    override func configureDataSource(dataSource: BlockTableDataSource) {
        dataSource.sections.append(
            TableSection(
                rows: [
                    TableRow(
                        configure: { cell in
                            cell.textLabel?.text = "Cell Types"
                        },
                        onSelect: { [unowned self] indexPath in
                            let testVC = CellExamplesViewController(style: .grouped)
                            testVC.title = "Cell Types"
                            self.navigationController?.pushViewController(testVC, animated: true)
                        }
                    ),
                    TableRow(
                        configure: { cell in
                            cell.textLabel?.text = "Editing"
                        },
                        onSelect: { [unowned self] indexPath in
                            let reorderVC = EditingViewController(style: .grouped)
                            reorderVC.title = "Editing"
                            self.navigationController?.pushViewController(reorderVC, animated: true)
                        }
                    )
                ]
            )
        )
    }
}
