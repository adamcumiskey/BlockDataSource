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
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let burger = UIImageView(image: UIImage(named: "lego_burger"))
//        let label = UILabel()
//        label.text = "🍌"
//        label.textAlignment = .center
//        
//        burger.contentMode = .scaleAspectFit
//        self.dataSource = BlockDataSource(
//            sections: [
//                Section(
//                    header: Section.HeaderFooter(
//                        title: "Examples",
//                        height: 30
//                    ),
//                    rows: [
//                        Row(
//                            cellClass: Cell.self,
//                            configure: { cell in
//                                guard let cell = cell as? Cell else { return }
//                                cell.textLabel?.text = "Basic Cell"
//                            },
//                            selectionStyle: .Blue
//                        ),
//                        Row(
//                            cellClass: SubtitleCell.self,
//                            configure: { cell in
//                                guard let cell = cell as? SubtitleCell else { return }
//                                cell.textLabel?.text = "Subtitle Cell"
//                                cell.detailTextLabel?.text = "This is a subtitle"
//                            }
//                        ),
//                        Row(
//                            cellClass: RightAlignedCell.self,
//                            configure: { cell in
//                                guard let cell = cell as? RightAlignedCell else { return }
//                                cell.textLabel?.text = "Switch"
//                                cell.detailTextLabel?.text = "Switch it up"
//                                
//                                let `switch` = UISwitch(
//                                    frame: CGRect(
//                                        origin: CGPointZero,
//                                        size: CGSize(
//                                            width: 75,
//                                            height: 30
//                                        )
//                                    )
//                                )
//                                cell.accessoryView = `switch`
//                            }
//                        )
//                    ],
//                    footer: Section.HeaderFooter(view: burger)
//                ),
//                Section(
//                    header: Section.HeaderFooter(view: label),
//                    rows: [
//                        Row(
//                            cellClass: ImageCell.self,
//                            configure: { cell in
//                                guard let cell = cell as? ImageCell else { return }
//                                cell.bigImageView.image = UIImage(named: "lego_burger")
//                            }
//                        )
//                    ]
//                )
//            ]
//        )
//    }
}
