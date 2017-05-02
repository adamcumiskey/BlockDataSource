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
    override func createDataSource() -> ListDataSource {
        return ListDataSource(
            sections: [
                Section(
                    items: [
                        ListItem(
                            configure: { cell in
                                cell.textLabel?.text = "Cell Types"
                            },
                            onSelect: { [unowned self] indexPath in
                                let testVC = CellExamplesViewController(style: .grouped)
                                testVC.title = "Cell Types"
                                self.navigationController?.pushViewController(testVC, animated: true)
                            }
                        ),
                        ListItem(
                            configure: { cell in
                                cell.textLabel?.text = "Editing"
                            },
                            onSelect: { [unowned self] indexPath in
                                let reorderVC = EditingViewController()
                                reorderVC.title = "Editing"
                                self.navigationController?.pushViewController(reorderVC, animated: true)
                            }
                        ),
                        ListItem(
                            configure: { cell in
                                cell.textLabel?.text = "Collection View"
                            },
                            onSelect: { [unowned self] indexPath in
                                let collectionVC = CollectionExampleViewController(collectionViewLayout: UICollectionViewFlowLayout())
                                collectionVC.collectionView?.backgroundColor = .groupTableViewBackground
                                collectionVC.title = "Collection View"
                                self.navigationController?.pushViewController(collectionVC, animated: true)
                            }
                        )
                    ]
                )
            ],
            middleware: [
                ListMiddleware { $0.textLabel?.font = .boldSystemFont(ofSize: 15) },
                ListMiddleware { (cell: UITableViewCell) in cell.accessoryType = .disclosureIndicator }
            ]
        )
    }
}
