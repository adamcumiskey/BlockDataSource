//
//  ExampleTableViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 7/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import BlockDataSource

class ExampleTableViewController: BlockTableViewController {

    override func configure(datasource: BlockDataSource) {
        datasource.sections.append(
            Section(
                header: Section.HeaderFooter(
                    title: "Examples",
                    height: 30
                ),
                rows: [
                    Row(
                        identifier: "Basic",
                        configure: { cell in
                            cell.textLabel?.text = "Basic Cell"
                        },
                        selectionStyle: .Blue
                    ),
                    Row(
                        identifier: "Subtitle",
                        configure: { cell in
                            cell.textLabel?.text = "Subtitle Cell"
                            cell.detailTextLabel?.text = "This is a subtitle"
                        }
                    ),
                    Row(
                        identifier: "Basic",
                        configure: { cell in
                            cell.textLabel?.text = "Switch"
                            
                            let `switch` = UISwitch(
                                frame: CGRect(
                                    origin: CGPointZero,
                                    size: CGSize(
                                        width: 75,
                                        height: 30
                                    )
                                )
                            )
                            cell.accessoryView = `switch`
                        }
                    )
                ]
            )
        )
    }
    
}
