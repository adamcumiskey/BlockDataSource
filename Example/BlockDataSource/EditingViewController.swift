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
    
    override var dataSource: BlockDataSource? {
        get {
            guard let data = data else { return nil }
            return BlockDataSource(
                section: Section(
                    rows: data.map { item in
                        return Row(
                            configure: item.configureCell,
                            onDelete: { [unowned self] indexPath in
                                if let index = self.data!.index(of: item) {
                                    self.data?.remove(at: index)
                                }
                            }
                        )
                    },
                    footer: tableView.isEditing ? .label("Press \"Done\" to stop editing") : .label("Press \"Edit\" to reorder")
                ),
                onReorder: { [unowned self] (firstIndex, secondIndex) in
                    self.data!.moveObjectAtIndex(firstIndex.row, toIndex: secondIndex.row)
                }
            )
        }
        set {
            
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
