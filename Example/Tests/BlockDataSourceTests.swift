//
//  BlockDataSourceTests.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 7/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import BlockDataSource

func basicRow() -> Row {
    return Row(
        identifier: "Basic",
        configure: { cell in
            cell.textLabel?.text = "Basic Cell"
        },
        selectionStyle: .Blue
    )
}

func customRow() -> Row {
    return Row(identifier: "", configure: { cell in
        
    })
}

func header() -> HeaderFooter {
    return HeaderFooter(title: "Header", height: 50.0)
}

func section() -> Section {
    return Section(
        header: header(),
        rows: [
            basicRow(),
            basicRow(),
            basicRow()
        ],
        footer: header()
    )
}

func blockDataSource() -> BlockDataSource {
    return BlockDataSource(
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
            ),
            Section(
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
                    )
                ],
                footer: HeaderFooter(
                    title: "Footer",
                    height: 100.0
                )
            )
        ]
    )
}


class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("a data source") {
            var dataSource: BlockDataSource!
            var sectionCount: Int!
            beforeEach {
                dataSource = blockDataSource()
                sectionCount = dataSource.sections.count
            }
            
            it("can add a new section") {
                dataSource.sections.append(section())
                expect(dataSource.sections.count).to(equal(sectionCount + 1))
            }
            
            it("can add new sections") {
                dataSource.sections.appendContentsOf([section(), section()])
                expect(dataSource.sections.count).to(equal(sectionCount + 2))
            }
            
            it("can delete a section") {
                dataSource.sections.removeLast()
                expect(dataSource.sections.count).to(equal(sectionCount - 1))
            }
            
            describe("its sections") {
                var section: Section!
                var rowCount: Int!
                beforeEach {
                    section = dataSource.sections.first
                    rowCount = section.rows.count
                }
                
                it("can add a row") {
                    section.rows.append(basicRow())
                    expect(section.rows.count).to(equal(rowCount + 1))
                }
                
                it("can delete a row") {
                    section.rows.removeLast()
                    expect(section.rows.count).to(equal(rowCount - 1))

                }
            }
        }
    }
}
