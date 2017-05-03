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

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.title == rhs.title
}



class EditingViewController: DataSourceTableViewController {

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
    
    override func createDataSource() -> ListDataSource {
        return ListDataSource(
            sections: [
                Section(
                    items: data.map { item in
                        return ListItem(
                            configure: { (cell: Cell) in
                                cell.textLabel?.text = item.title
                            },
                            onDelete: { [unowned self] indexPath in
                                if let index = self.data.index(of: item) {
                                    self.data.remove(at: index)
                                }
                            }
                        )
                    }
                )
            ],
            onReorder: { [unowned self] (firstIndex, secondIndex) in
                self.data.moveObjectAtIndex(firstIndex.row, toIndex: secondIndex.row)
            }
        )
    }
}
