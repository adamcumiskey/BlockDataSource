//
//  Middleware.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BlockDataSource

extension Middleware {
    static var noCellSelectionStyle = Middleware { (cell: UITableViewCell, _, _) in
        cell.selectionStyle = .none
    }
    
    static var cellGradient = Middleware { (cell: UITableViewCell, indexPath: IndexPath, sections: [Section]) in
        let normalized = CGFloat(Double(indexPath.row) / Double(sections[indexPath.section].items.count))
        let backgroundColor = UIColor(white: 1-normalized, alpha: 1.0)
        let textColor = UIColor(white: normalized, alpha: 1.0)
        cell.contentView.backgroundColor = backgroundColor
        cell.textLabel?.textColor = textColor
        cell.detailTextLabel?.textColor = textColor
    }
    
    static var noTableSeparator = Middleware { (tableView: UITableView, _, _) in
        tableView.separatorStyle = .none
    }
    
    static var disclosureIndicators = Middleware { (cell: UITableViewCell, _, _) in
        cell.accessoryType = .disclosureIndicator
    }
}
