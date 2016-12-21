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
            contentsOf: [
                List.Section(
                    header: .label("UITableView"),
                    rows: [
                        List.Row(
                            configure: { (cell: UITableViewCell) in
                                cell.textLabel?.text = "Examples"
                                cell.accessoryType = .disclosureIndicator
                            },
                            onSelect: { [unowned self] indexPath in
                                let testVC = CellExamplesViewController(style: .grouped)
                                testVC.title = "Examples"
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
                                cell.textLabel?.text = "Animations"
                                cell.accessoryType = .disclosureIndicator
                            },
                            onSelect: { [unowned self] indexPath in
                                let animationVC = AnimatedListViewController(style: .grouped)
                                animationVC.title = "Animations"
                                self.navigationController?.pushViewController(animationVC, animated: true)
                            }
                        )
                    ]
                ),
                List.Section(
                    header: .label("UICollectionView"),
                    rows: [
                        List.Row(
                            configure: { cell in
                                cell.textLabel?.text = "Reordering"
                                cell.accessoryType = .disclosureIndicator
                            },
                            onSelect: { [unowned self] indexPath in
                                let collectionVC = CollectionExampleViewController(collectionViewLayout: UICollectionViewFlowLayout())
                                collectionVC.collectionView?.backgroundColor = .groupTableViewBackground
                                collectionVC.title = "Press and hold to reorder"
                                self.navigationController?.pushViewController(collectionVC, animated: true)
                            }
                        ),
                        List.Row(
                            configure: { cell in
                                cell.textLabel?.text = "Animations"
                                cell.accessoryType = .disclosureIndicator
                            },
                            onSelect: { [unowned self] indexPath in
                                let animationVC = AnimatedGridViewController(collectionViewLayout: UICollectionViewFlowLayout())
                                animationVC.collectionView?.backgroundColor = .groupTableViewBackground
                                animationVC.title = "Press 'Toggle' to animate"
                                self.navigationController?.pushViewController(animationVC, animated: true)
                            }
                        )
                    ]
                )
            ]
        )
    }
}
