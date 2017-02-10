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
    override func configureDataSource(dataSource: List) {
        dataSource.sections = [
            List.Section(
                header: .label("Examples"),
                rows: [
                    List.Row { cell in
                        cell.textLabel?.text = "Basic Cell"
                    },
                    List.Row { (cell: SubtitleCell) in
                        cell.textLabel?.text = "Subtitle Cell"
                        cell.detailTextLabel?.text = "This is a subtitle"
                    },
                    List.Row { (cell: RightAlignedCell) in
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
            List.Section(
                header: .label("Burger Section 🍔"),
                rows: [
                    List.Row { (cell: ImageCell) in
                        cell.bigImageView.image = UIImage(named: "lego_burger")
                    }
                ],
                footer:.customView({
                    let view = UIImageView(image: UIImage(named: "king_burger"))
                    view.contentMode = .scaleAspectFit
                    return view
                }(),
                    height: 300
                )
            )
        ]
        
        let subtitleItalics = Middleware { $0.0.detailTextLabel?.font = .italicSystemFont(ofSize: 12) }
        let aspectPhil = Middleware { (cell: ImageCell, indexPath: IndexPath, structure: [List.Section]) in
            cell.bigImageView.contentMode = .scaleAspectFit
        }
        dataSource.middlewareStack = [subtitleItalics, aspectPhil]
    }
}
