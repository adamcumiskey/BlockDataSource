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
    override func configure(dataSource: DataSource) {
        dataSource.sections = [
            Section(
                items: [
                    Item(
                        onSelect: { [unowned self] indexPath in
                            let testVC = CellExamplesViewController(style: .grouped)
                            testVC.title = "Cell Types"
                            self.navigationController?.pushViewController(testVC, animated: true)
                        },
                        configure: { (cell: UITableViewCell) in
                            cell.textLabel?.text = "Cell Types"
                        }
                    ),
                    Item(
                        onSelect: { [unowned self] indexPath in
                            let reorderVC = EditingViewController()
                            reorderVC.title = "Editing"
                            self.navigationController?.pushViewController(reorderVC, animated: true)
                        },
                        configure: { (cell: UITableViewCell) in
                            cell.textLabel?.text = "Editing"
                        }
                    ),
                    Item(
                        onSelect: { [unowned self] indexPath in
                            let collectionVC = CollectionExampleViewController(collectionViewLayout: UICollectionViewFlowLayout())
                            collectionVC.collectionView?.backgroundColor = .groupTableViewBackground
                            collectionVC.title = "Collection View"
                            self.navigationController?.pushViewController(collectionVC, animated: true)
                        },
                        configure: { (cell: UITableViewCell) in
                            cell.textLabel?.text = "Collection View"
                        }
                    )
                ]
            )
        ]
        dataSource.middleware = [
            Middleware { (cell: UITableViewCell, _, _) in cell.textLabel?.font = .boldSystemFont(ofSize: 15) },
            Middleware { (cell: UITableViewCell, _, _) in cell.accessoryType = .disclosureIndicator }
        ]
    }
}
