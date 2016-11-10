//
//  BlockCollectionViewController.swift
//  Pods
//
//  Created by Adam Cumiskey on 11/10/16.
//
//

import Foundation


extension BlockConfigureable where Self: BlockCollectionViewController {
    public func reloadUI() {
        guard let collectionView = collectionView else { return }
        dataSource?.registerReuseIdentifiers(to: collectionView)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        collectionView.reloadData()
    }
}



public class BlockCollectionViewController: UICollectionViewController, BlockConfigureable {
    public var dataSource: BlockDataSource? {
        didSet {
            reloadUI()
        }
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadUI()
    }
}
