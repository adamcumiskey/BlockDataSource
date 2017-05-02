//
//  GridViewController.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import UIKit

class GridViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!

    var dataSource: GridDataSource {
        didSet { reload() }
    }

    init(dataSource: GridDataSource) {
        self.dataSource = dataSource
        super.init(nibName: "GridViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    func reload() {
        guard let collectionView = collectionView else { return }
        collectionView.registerReuseIdentifiers(forDataSource: dataSource)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        collectionView.reloadData()
    }

}
