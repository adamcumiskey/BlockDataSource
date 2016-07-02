//
//  BlockDataSourceSection.swift
//  bestroute
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit

struct BlockDataSourceSection {
    
    var rows: [BlockDataSourceRow] = []
    var title: String?
    var detailText: String?
    var headerHeight: CGFloat = 30
    var footerHeight: CGFloat = 50
    
    init(title: String? = nil, rows: [BlockDataSourceRow] = []) {
        self.title = title
        self.rows = rows
    }
    
    mutating func addRow(row: BlockDataSourceRow) {
        rows.append(row)
    }
    
    mutating func removeRowAtIndex(index: Int) {
        rows.removeAtIndex(index)
    }
    
}