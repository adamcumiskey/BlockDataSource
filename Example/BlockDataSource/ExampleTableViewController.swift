//  The MIT License (MIT)
//
//  Copyright (c) 2016 Adam Cumiskey
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
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
