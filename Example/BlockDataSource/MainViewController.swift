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
    override func configureDataSource(dataSource: List) {
        dataSource.sections.append(
            List.Section(
                rows: [
                    List.Row(
                        configure: { cell in
                            cell.textLabel?.text = "Cell Types"
                            cell.accessoryType = .disclosureIndicator
                        },
                        onSelect: { [unowned self] indexPath in
                            let testVC = CellExamplesViewController(style: .grouped)
                            testVC.title = "Cell Types"
                            self.navigationController?.pushViewController(testVC, animated: true)
                        }
                    ),
                    List.Row(
                        configure: { cell in
                            cell.textLabel?.text = "Editing"
                            cell.accessoryType = .disclosureIndicator
                        },
                        onSelect: { [unowned self] indexPath in
                            let reorderVC = EditingViewController()
                            reorderVC.title = "Editing"
                            self.navigationController?.pushViewController(reorderVC, animated: true)
                        }
                    ),
                    List.Row(
                        configure: { cell in
                            cell.textLabel?.text = "Collection View"
                            cell.accessoryType = .disclosureIndicator
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
        )
    }
}
