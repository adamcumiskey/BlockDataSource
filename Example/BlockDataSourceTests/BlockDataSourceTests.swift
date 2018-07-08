//
//  BlockDataSourceTests.swift
//  BlockDataSourceTests
//
//  Created by Adam on 6/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

@testable import BlockDataSource
import Quick
import Nimble

class BlockDataSourceTests: QuickSpec {
    override func spec() {
        describe("The DataSource") {
            context("for a UITableView") {
                var dataSource: DataSource!
                var tableView: UITableView!
                beforeEach {
                    tableView = UITableView(frame: .zero)
                    dataSource = DataSource(
                        sections: [
                            
                        ]
                    )
                }
                it("should provide items to the tableview") {
                    
                }
            }
        }
    }
}

extension UITableView {
    func register(dataSource: DataSource) {
        self.registerReuseIdentifiers(forDataSource: dataSource)
        self.delegate = dataSource
        self.dataSource = dataSource
        self.reloadData()
    }
}
