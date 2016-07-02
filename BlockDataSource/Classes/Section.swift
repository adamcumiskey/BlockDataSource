//
//  Section.swift
//  bestroute
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit

struct Section {
    
    var rows: [Row] = []
    var title: String?
    var detailText: String?
    var headerHeight: CGFloat = 30
    var footerHeight: CGFloat = 50
    
    init(title: String? = nil, rows: [Row] = []) {
        self.title = title
        self.rows = rows
    }
    
    mutating func addRow(row: Row) {
        rows.append(row)
    }
    
    mutating func removeRowAtIndex(index: Int) {
        rows.removeAtIndex(index)
    }
    
}