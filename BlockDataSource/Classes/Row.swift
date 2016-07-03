//
//  Row.swift
//  bestroute
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit

typealias ConfigBlock = (cell: UITableViewCell) -> Void
typealias ActionBlock = (indexPath: NSIndexPath) -> Void

struct Row {
    
    var identifier: String
    var configure: ConfigBlock
    var onSelect: ActionBlock?
    var onDelete: ActionBlock?
    var selectionStyle = UITableViewCellSelectionStyle.None
    var reorderable = false
    
    init(identifier: String, configure: ConfigBlock, onSelect: ActionBlock? = nil, onDelete: ActionBlock? = nil, selectionStyle: UITableViewCellSelectionStyle = .None, reorderable: Bool = true) {
        self.identifier = identifier
        self.configure = configure
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.selectionStyle = selectionStyle
        self.reorderable = reorderable
    }
}