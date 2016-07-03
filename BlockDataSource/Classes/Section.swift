//
//  Section.swift
//  bestroute
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit


struct Section {
    
    struct HeaderFooter {
        var title: String?
        var height: CGFloat
        
        init(title: String? = nil, height: CGFloat) {
            self.title = title
            self.height = height
        }
    }
    
    var header: HeaderFooter
    var rows: [Row]
    var footer: HeaderFooter
    
    init(header: HeaderFooter = HeaderFooter(height: 30), rows: [Row], footer: HeaderFooter = HeaderFooter(height: 50)) {
        self.header = header
        self.rows = rows
        self.footer = footer
    }
}