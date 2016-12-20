//
//  AnimatedViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 11/29/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import BlockDataSource


class AnimatedViewController: BlockTableViewController {
    
    let dataset1 = (2..<5).map { Item(title: "\($0)") }
    let dataset2 = (0..<1).map { Item(title: "\($0)") }
    let dataset3 = (5..<9).map { Item(title: "\($0)") }
    let dataset4 = (1..<3).map { Item(title: "\($0)") }
    
    var toggle: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Toggle", style: .plain, target: self, action: #selector(toggleValue))
    }
    
    func toggleValue() {
        toggle = !toggle
        reloadDataAndUI(animated: true)
    }
    
    override func configureDataSource(dataSource: List) {
        let section1 = toggle ? dataset1 : dataset2
        let section2 = toggle ? dataset3 : dataset4
        dataSource.sections.append(
            contentsOf: [
                List.Section(
                    rows: section1.map { item in
                        return List.Row(identifier: item.title, reorderable: false) { (cell: Cell) in
                            cell.textLabel?.text = item.title
                        }
                    }
                ),
                List.Section(
                    rows: section2.map { item in
                        return List.Row(identifier: item.title, reorderable: false) { (cell: Cell) in
                            cell.textLabel?.text = item.title
                        }
                    }
                )
            ]
        )
    }
}
