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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let burger = UIImageView(image: UIImage(named: "lego_burger"))
        let label = UILabel()
        label.text = "🍌"
        label.textAlignment = .center
        
        burger.contentMode = .scaleAspectFit
        self.dataSource = BlockDataSource(
            sections: [
                Section(
                    header: Section.HeaderFooter(
                        title: "Examples",
                        height: 30
                    ),
                    rows: [
                        Row(
                            configure: { cell in
                                cell.textLabel?.text = "Basic Cell"
                            },
                            selectionStyle: .blue
                        ),
                        Row(
                            configure: { (cell: SubtitleCell) in
                                cell.textLabel?.text = "Subtitle Cell"
                                cell.detailTextLabel?.text = "This is a subtitle"
                            }
                        ),
                        Row(
                            configure: { (cell: RightAlignedCell) in
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
                        )
                    ],
                    footer: Section.HeaderFooter(view: burger)
                ),
                Section(
                    header: Section.HeaderFooter(view: label),
                    rows: [
                        Row(
                            configure: { (cell: ImageCell) in
                                cell.bigImageView.image = UIImage(named: "lego_burger")
                            }
                        )
                    ]
                )
            ]
        )
    }
}
