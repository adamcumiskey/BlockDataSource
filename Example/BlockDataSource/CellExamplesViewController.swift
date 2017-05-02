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
    override func configureDataSource(dataSource: DataSource) {
        dataSource.sections = [
            DataSource.Section(
                items: [
                    DataSource.ListItem { (cell: Cell) -> Void in
                        cell.textLabel?.text = "Basic Cell"
                    },
                    DataSource.ListItem { (cell: SubtitleCell) in
                        cell.textLabel?.text = "Subtitle Cell"
                        cell.detailTextLabel?.text = "This is a subtitle"
                    },
                    DataSource.ListItem { (cell: RightAlignedCell) in
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
            DataSource.Section(
                items: [
                    DataSource.ListItem { (cell: ImageCell) in
                        cell.bigImageView.image = UIImage(named: "lego_burger")
                    }
                ]
            )
        ]
        
        let subtitleItalics = Middleware { $0.detailTextLabel?.font = .italicSystemFont(ofSize: 12) }
        let aspectPhil = Middleware { (cell: ImageCell) in cell.bigImageView.contentMode = .scaleAspectFill }
        dataSource.middlewareStack = [subtitleItalics, aspectPhil]
    }
}
