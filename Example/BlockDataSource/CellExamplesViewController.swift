//
//  CellExamplesViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 11/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import BlockDataSource


class CellExamplesViewController: BlockTableViewController {
    override func configure(dataSource: DataSource) {

        dataSource.sections = [
            Section(
                items: [
                    Item { (cell: UITableViewCell) -> Void in
                        cell.textLabel?.text = "Basic Cell"
                    },
                    Item { (cell: SubtitleCell) in
                        cell.textLabel?.text = "Subtitle Cell"
                        cell.detailTextLabel?.text = "This is a subtitle"
                    },
                    Item { (cell: RightAlignedCell) in
                        cell.textLabel?.text = "Switch"
                        cell.detailTextLabel?.text = "Switch it up"

                        let `switch` = UISwitch(
                            frame: CGRect(
                                origin: CGPoint.zero,
                                size: CGSize(
                                    width: 75,
                                    height: 30
                                )
                            )
                        )
                        cell.accessoryView = `switch`
                    }
                ],
                footer: Reusable { (banner: ImageTableHeaderFooterView) in
                    banner.imageView.image = #imageLiteral(resourceName: "king_burger")
                }
            )
        ]
        dataSource.middleware = [
            Middleware { (cell: SubtitleCell, _, _) in cell.detailTextLabel?.font = .italicSystemFont(ofSize: 12) },
            Middleware { (cell: ImageCell, _, _) in cell.bigImageView.contentMode = .scaleAspectFill }
        ]
    }
}
