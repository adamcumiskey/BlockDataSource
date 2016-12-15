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
    override func configureDataSource(dataSource: TableData) {
        let burgerView = UIImageView(image: UIImage(named: "king_burger"))
        burgerView.contentMode = .scaleAspectFit

        dataSource.sections = [
            TableData.Section(
                header: .label("Examples"),
                rows: [
                    TableData.Row { cell in
                        cell.textLabel?.text = "Basic Cell"
                    },
                    TableData.Row { (cell: SubtitleCell) in
                        cell.textLabel?.text = "Subtitle Cell"
                        cell.detailTextLabel?.text = "This is a subtitle"
                    },
                    TableData.Row { (cell: RightAlignedCell) in
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
            ),
            TableData.Section(
                header: .label("Burger Section 🍔"),
                rows: [
                    TableData.Row() { (cell: ImageCell) in
                        cell.bigImageView.image = UIImage(named: "lego_burger")
                    }
                ],
                footer: .customView(burgerView, height: 100)
            )
        ]
    }
}
