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
//  Middleware.swift
//  BlockDataSource
//
//  Created by Adam on 6/26/18.
//

import Foundation

// MARK: - Middleware

/** Middleware allows you to customize views in a generic way.
 
 The datasource will apply its middleware to any views who have a supertype matching the type passed into the `apply` closure.
 
 
 CAUTION: Middleware is currently very inefficient. Every time a cell is about to be reconfigured it reapplies the midleware in O(n) time.
 I haven't experinced performance issues but YMMV.
 */

public struct TableViewCellMiddleware {
    public var apply: (_ cell: UITableViewCell, _ indexPath: IndexPath, _ context: DataSource) -> Void
    
    public init<View: UITableViewCell>(apply: @escaping (View, IndexPath, DataSource) -> Void) {
        self.apply = { view, indexPath, context in
            if let view = view as? View {
                apply(view, indexPath, context)
            }
        }
    }
}

public struct TableViewMiddleware {
    public var apply: (_ tableView: UITableView) -> Void
    
    public init<View: UITableView>(apply: @escaping (View) -> Void) {
        self.apply = { view in
            if let view = view as? View {
                apply(view)
            }
        }
    }
}

public struct TableViewHeaderFooterViewMiddleware {
    public var apply: (_ headerFooterView: UITableViewHeaderFooterView, _ section: Int, _ context: DataSource) -> Void
    
    public init<View: UITableViewHeaderFooterView>(apply: @escaping (View, Int, DataSource) -> Void) {
        self.apply = { view, section, context in
            if let view = view as? View {
                apply(view, section, context)
            }
        }
    }
}

public struct CollectionViewCellMiddleware {
    public var apply: (_ cell: UICollectionViewCell, _ indexPath: IndexPath, _ context: DataSource) -> Void

    public init<View: UICollectionViewCell>(apply: @escaping (View, IndexPath, DataSource) -> Void) {
        self.apply = { view, indexPath, context in
            if let view = view as? View {
                apply(view, indexPath, context)
            }
        }
    }
}

public struct CollectionViewMiddleware {
    public var apply: (_ collectionView: UICollectionView) -> Void
    
    public init<View: UICollectionView>(apply: @escaping (View) -> Void) {
        self.apply = { view in
            if let view = view as? View {
                apply(view)
            }
        }
    }
}

public struct CollectionReusableViewMiddlware {
    public var apply: (_ reusableView: UICollectionReusableView, _ indexPath: IndexPath, _ context: DataSource) -> Void

    public init<View: UICollectionReusableView>(apply: @escaping (View, IndexPath, DataSource) -> Void) {
        self.apply = { view, indexPath, context in
            if let view = view as? View {
                apply(view, indexPath, context)
            }
        }
    }
}
