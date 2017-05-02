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
//  BlockTableViewController.swift
//
//  Created by Adam Cumiskey on 6/17/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit



open class BlockTableViewController: UITableViewController {
    public var dataSource: ListDataSource?
    
    open func createDataSource() -> ListDataSource {
        return ListDataSource()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataAndUI()
    }

    public func reloadDataAndUI() {
        guard let tableView = tableView else { return }

        let dataSource = createDataSource()

        tableView.registerReuseIdentifiers(forDataSource: dataSource)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource

        self.dataSource = dataSource
        tableView.reloadData()
    }
}


open class BlockCollectionViewController: UICollectionViewController {
    public var dataSource: GridDataSource?

    open func createDataSource() -> GridDataSource {
        return GridDataSource()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataAndUI()
    }

    public func reloadDataAndUI() {
        guard let collectionView = collectionView else { return }

        let dataSource = createDataSource()

        collectionView.registerReuseIdentifiers(forDataSource: dataSource)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource

        self.dataSource = dataSource
        collectionView.reloadData()
    }
}

