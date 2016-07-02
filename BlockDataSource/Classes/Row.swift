//
//  Row.swift
//  Pods
//
//  Created by Adam Cumiskey on 7/1/16.
//
//

import Foundation


struct Row<UITableViewCellType: UITableViewCell> {
    typealias CellConfigBlock = UITableViewCellType -> Void
    typealias RowEventBlock = (NSIndexPath, UITableViewCellType) -> Void
    
    var cell: UITableViewCellType?
    var configure: CellConfigBlock
    var onSelect: RowEventBlock?
    var onDelete: RowEventBlock?
    var reorderable: Bool
    var selectionStyle: UITableViewCellSelectionStyle
    
    init(configure: CellConfigBlock, onSelect: RowEventBlock?, onDelete: RowEventBlock?, reorderable: Bool = true, selectionStyle: UITableViewCellSelectionStyle = .None) {
        self.configure = configure
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.reorderable = reorderable
        self.selectionStyle = selectionStyle
    }
}


struct Section {
    var rows: [Row]
}