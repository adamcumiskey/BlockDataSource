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



class EditingViewController: BlockTableViewController {
    
    var data: [Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem()
        data = (0..<5).map { Item(title: "\($0)") }
        createDataSource()
    }
        
    func createDataSource() {
        if let data = data {
            dataSource = BlockDataSource(
                rows: data.map { item in
                    return Row(
                        cellClass: Cell.self,
                        configure: { cell in
                            cell.textLabel?.text = item.title
                        },
                        onDelete: { [unowned self] indexPath in
                            if let index = self.data!.indexOf(item) {
                                self.data?.removeAtIndex(index)
                            }
                        }
                    )
                },
                onReorder: { [unowned self] (firstIndex, secondIndex) in
                    self.data!.moveObjectAtIndex(firstIndex, toIndex: secondIndex)
                    self.createDataSource()
                }
            )
        } else {
            dataSource = nil
        }
        
    }
    
}


extension Array {
    mutating func moveObjectAtIndex(index: Int, toIndex: Int) {
        let element = self[index]
        removeAtIndex(index)
        insert(element, atIndex: toIndex)
    }
}
