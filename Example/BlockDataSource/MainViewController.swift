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
    override func configureDataSource(dataSource: BlockDataSource) {
        dataSource.sections.append(
            Section(
                rows: [
                    Row(
                        configure: { cell in
                            cell.textLabel?.text = "Cell Types"
                        },
                        onSelect: { [unowned self] indexPath in
                            let testVC = CellExamplesViewController(style: .grouped)
                            testVC.title = "Cell Types"
                            self.navigationController?.pushViewController(testVC, animated: true)
                        }
                    ),
                    Row(
                        configure: { cell in
                            cell.textLabel?.text = "Editing"
                        },
                        onSelect: { [unowned self] indexPath in
                            let reorderVC = EditingViewController(style: .grouped)
                            reorderVC.title = "Editing"
                            self.navigationController?.pushViewController(reorderVC, animated: true)
                        }
                    ),
                    Row(
                        configure: { cell in
                            cell.textLabel?.text = "Animations"
                        },
                        onSelect: { [unowned self] indexPath in
                            let controller = AnimatedViewController()
                            controller.title = "Animations"
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    )
                ]
            )
        )
    }
}
