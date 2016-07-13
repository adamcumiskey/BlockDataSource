//
//  BlockDataSourceTests.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 7/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import BlockDataSource


let fullTestCase = BlockDataSource(
    sections: [
        Section(
            header: HeaderFooter(
                title: "Examples",
                height: 30
            ),
            rows: [
                Row(
                    identifier: "Basic",
                    configure: { cell in
                        cell.textLabel?.text = "Basic Cell"
                    },
                    selectionStyle: .Blue
                ),
                Row(
                    identifier: "Subtitle",
                    configure: { cell in
                        cell.textLabel?.text = "Subtitle Cell"
                        cell.detailTextLabel?.text = "This is a subtitle"
                    }
                ),
                Row(
                    identifier: "Basic",
                    configure: { cell in
                        cell.textLabel?.text = "Switch"
                        
                        let `switch` = UISwitch(
                            frame: CGRect(
                                origin: CGPointZero,
                                size: CGSize(
                                    width: 75,
                                    height: 30
                                )
                            )
                        )
                        cell.accessoryView = `switch`
                    }
                )
            ]
        )
    ]
)

class BlockDataSourceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
