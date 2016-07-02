//
//  BlockDataSourceRow.swift
//  bestroute
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit

let DefaultCellIdentifier = "Cell"

typealias TableViewCellConfigBlock = (cell: UITableViewCell) -> Void
typealias CollectionViewCellConfigBlock = (cell: UICollectionViewCell) -> Void
typealias RowActionBlock = (indexPath: NSIndexPath) -> Void

struct BlockDataSourceRow {
    
    var identifier: String
    var configure: TableViewCellConfigBlock
    var select: RowActionBlock?
    var onDelete: RowActionBlock?
    var canMove = true
    var selectionStyle = UITableViewCellSelectionStyle.None
    var reorderable = false
    
    init(identifier: String, configure: TableViewCellConfigBlock, select: RowActionBlock?) {
        self.identifier = identifier
        self.configure = configure
        self.select = select
    }
    
    init(identifier: String, configure: TableViewCellConfigBlock, select: RowActionBlock?, onDelete: RowActionBlock?) {
        self.init(identifier: identifier, configure: configure, select: select)
        self.onDelete = onDelete
    }
    
    init(identifier: String, configure: TableViewCellConfigBlock) {
        self.init(identifier: identifier, configure: configure, select: nil)
    }
    
    init(configure: TableViewCellConfigBlock, select: RowActionBlock?) {
        self.init(identifier: DefaultCellIdentifier, configure: configure, select: select)
    }
    
    init(configure: TableViewCellConfigBlock) {
        self.init(identifier: DefaultCellIdentifier, configure: configure, select: nil)
    }
}