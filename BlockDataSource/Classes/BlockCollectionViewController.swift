//
//  BlockCollectionViewController.swift
//  Pods
//
//  Created by Adam Cumiskey on 11/10/16.
//
//

import Foundation


//extension BlockConfigureable where Self: BlockCollectionViewController {
//    public func reloadUI() {
//        guard let collectionView = collectionView else { return }
//        dataSource?.registerReuseIdentifiers(to: collectionView)
//        collectionView.dataSource = dataSource
//        collectionView.delegate = dataSource
//        collectionView.reloadData()
//    }
//}
//
//
//
//open class BlockCollectionViewController: UICollectionViewController, BlockConfigureable {
//    open var dataSource: BlockTableDataSource? {
//        didSet {
//            reloadUI()
//        }
//    }
//    
//    override open func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        reloadUI()
//    }
//}
