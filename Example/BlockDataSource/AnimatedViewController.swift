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
    
    let dataset1 = (0..<10).map { Item(title: "\($0)") }
    let dataset2 = (3..<17).map { Item(title: "\($0)") }
    
    var toggle: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Toggle", style: .plain, target: self, action: #selector(toggleValue))
    }
    
    func toggleValue() {
        toggle = !toggle
        reloadUI(animated: true)
    }
    
    override func configureDataSource(dataSource: BlockDataSource) {
        let dataset = toggle ? dataset1 : dataset2
        dataSource.sections.append(
            Section(
                rows: dataset.map { item in
                    return Row(rowID: item.title) { cell in
                        cell.textLabel?.text = item.title
                    }
                }
            )
        )
    }
}
