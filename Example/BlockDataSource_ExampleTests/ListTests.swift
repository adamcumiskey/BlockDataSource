//
//  ListTests.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 12/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import BlockDataSource


class ListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCanCreateListWithOnlyRows() {
        let list = List(
            rows: [
                List.Row { (cell: UITableViewCell) in
                    cell.textLabel?.text = "Test row"
                },
                List.Row { (cell: UITableViewCell) in
                    cell.textLabel?.text = "Test row"
                },
                List.Row { (cell: UITableViewCell) in
                    cell.textLabel?.text = "Test row"
                }
            ]
        )
        
        XCTAssert(list.sections.count == 1)
        XCTAssertNil(list.sections[0].header)
        XCTAssert(list.sections[0].rows.count == 3)
        XCTAssertNil(list.sections[0].footer)
    }
    
    func testCanCreateListSectionWithHeaderFooters() {
        let section = List.Section(
            header: .label("Header"),
            row: List.Row { (cell: UITableViewCell) in
                cell.textLabel?.text = "Test row"
            },
            footer: .customView(UIView(), height: 150)
        )
        
        XCTAssertEqual(section.header?.text, "Header")
        XCTAssert(section.rows.count == 1)
        XCTAssertNotNil(section.footer?.view)
    }
    
}
