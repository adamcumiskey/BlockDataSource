//  The MIT License (MIT)
//
//  Copyright (c) 2016 Adam Cumiskey
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//
//  DataSource.swift
//
//  Created by Adam Cumiskey on 6/16/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.


import Foundation


public protocol DataSourceProtocol {
    associatedtype DataSourceType: DataSourceTypeProtocol
    var sections: [Section<DataSourceType>] { get set }
    var onReorder: ReorderBlock? { get set }
    var onScroll: ScrollBlock? { get set }
    var middleware: [DataSourceType.Middleware] { get set }
}

extension DataSourceProtocol {
    // Reference section with `DataSource[index]`
    public subscript(index: Int) -> Section<DataSourceType> {
        return sections[index]
    }

    // Reference item with `DataSource[indexPath]`
    public subscript(indexPath: IndexPath) -> DataSourceType.Item {
        return sections[indexPath.section].items[indexPath.item]
    }
}


public class DataSource<DataSourceType: DataSourceTypeProtocol>: NSObject, DataSourceProtocol, UIScrollViewDelegate {
    public var sections: [Section<DataSourceType>]
    public var onReorder: ReorderBlock?
    public var onScroll: ScrollBlock?
    public var middleware: [DataSourceType.Middleware]
    public var type: DataSourceType

    /**
     Initialize a DataSource

     - parameters:
     - sections: The array of sections in this DataSource
     - onReorder: Optional callback for when items are moved. You should update the order your underlying data in this callback. If this property is `nil`, reordering will be disabled for this TableView
     - onScroll: Optional callback for recieving scroll events from UIScrollViewDelegate
     */
    public init(sections: [Section<DataSourceType>], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil, middleware: [DataSourceType.Middleware] = []) {
        self.type = DataSourceType()
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
        self.middleware = middleware
    }

    public convenience override init() {
        self.init(items: [])
    }

    /// Convenience init for a DataSource with a single section
    public convenience init(section: Section<DataSourceType>, onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [section],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }

    /// Convenience init for a DataSource with a single section with no headers/footers
    public convenience init(items: [DataSourceType.Item], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [Section<DataSourceType>(items: items)],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }


    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let onScroll = onScroll {
            onScroll(scrollView)
        }
    }

}
