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

    var data: [Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        data = (0..<5).map { Item(title: "\($0)") }
    }
    
    override func configureDataSource(dataSource: BlockDataSource) {
        guard let data = data else { return }
        dataSource.sections = [
            Section(
                rows: data.map { item in
                    return Row(
                        rowID: item.title,
                        configure: item.configureCell,
                        onDelete: { [unowned self] indexPath in
                            if let index = self.data!.index(of: item) {
                                self.data?.remove(at: index)
                            }
                        }
                    )
                }
            )
        ]
        dataSource.onReorder = { [unowned self] (firstIndex, secondIndex) in
            self.data!.moveObjectAtIndex(firstIndex.row, toIndex: secondIndex.row)
            self.reloadUI()
        }
    }
}


extension Array {
    mutating func moveObjectAtIndex(_ index: Int, toIndex: Int) {
        let element = self[index]
        remove(at: index)
        insert(element, at: toIndex)
    }
}
