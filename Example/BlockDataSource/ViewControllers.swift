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
                    items: (0..<50).map { item in
                        return Item { (cell: UITableViewCell) in
                            cell.textLabel?.text = "\(item)"
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

class ExampleCollectionViewController: BlockCollectionViewController {
    lazy var items: [UIImage] = {
        return (0..<30).map { _ in
            let rand = arc4random_uniform(100)
            if rand % 2 == 0 {
                return #imageLiteral(resourceName: "king_burger")
            } else {
                return #imageLiteral(resourceName: "lego_burger")
            }
        }
    }()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = .init(width: UIScreen.main.bounds.width, height: 100)
        super.init(collectionViewLayout: layout)
        self.title = "Reordering"
        self.collectionView?.backgroundColor = .white
        self.dataSource = DataSource(
            sections: [
                Section(
                    header: Reusable { (view: InformationCollectionReusableView) in
                        view.textLabel.text = "Press and hold on a cell for a few moments, then drag and drop to reorder."
                    },
                    items: items.map { item in
                        return Item(reorderable: true) { (cell: ImageCollectionViewCell) in
                            cell.imageView.image = item
                        }
                    }
                )
            ],
            onReorder: { [unowned self] origin, destination in
                self.items.moveObjectAtIndex(origin.item, toIndex: destination.item)
            }
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
