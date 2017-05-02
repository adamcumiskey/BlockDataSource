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
    override func createDataSource() -> DataSource {
        return DataSource(
            sections: [
                DataSource.Section(
                    items: [
                        GenericItem { (cell: Cell) -> Void in
                            cell.textLabel?.text = "Basic Cell"
                        },
                        GenericItem { (cell: SubtitleCell) in
                            cell.textLabel?.text = "Subtitle Cell"
                            cell.detailTextLabel?.text = "This is a subtitle"
                        },
                        GenericItem { (cell: RightAlignedCell) in
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
                    ]
                )
            ],
            middleware: [
                ListMiddleware { (cell: SubtitleCell) in cell.detailTextLabel?.font = .italicSystemFont(ofSize: 12) },
                ListMiddleware { (cell: ImageCell) in cell.bigImageView.contentMode = .scaleAspectFill }
            ]
        )
    }
}
