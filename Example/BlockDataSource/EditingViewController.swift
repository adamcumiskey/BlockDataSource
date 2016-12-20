//
//  EditingViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 11/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import BlockDataSource


struct Item: Equatable {
    var title: String
}

extension Item {
    func configureCell(cell: Cell) -> Void {
        cell.textLabel?.text = title
    }
}

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.title == rhs.title
}



class EditingViewController: BlockTableViewController {

    var data: [Item]
    init() {
        data = (0..<5).map { Item(title: "\($0)") }
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func configureDataSource(dataSource: List) {
        dataSource.sections = [
            List.Section(
                rows: data.map { item in
                    return List.Row(
                        configure: item.configureCell,
                        onDelete: { [unowned self] indexPath in
                            if let index = self.data.index(of: item) {
                                self.data.remove(at: index)
                            }
                        }
                    )
                }
            )
        ]
        dataSource.onReorder = { [unowned self] (firstIndex, secondIndex) in
            self.data.moveObjectAtIndex(firstIndex.row, toIndex: secondIndex.row)
        }
    }
}
