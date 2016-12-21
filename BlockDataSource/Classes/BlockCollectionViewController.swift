//
//  BlockCollectionViewController.swift
//  Pods
//
//  Created by Adam Cumiskey on 11/10/16.
//
//

import Foundation


public protocol ConfigurableCollection: class {
    var dataSource: Grid? { get set }
    func configureDataSource(dataSource: Grid)
}

public extension ConfigurableCollection where Self: UICollectionViewController {
    public func createDataSource() -> Grid {
        guard let collectionView = collectionView else { return Grid() }
        
        let dataSource = Grid()
        configureDataSource(dataSource: dataSource)
        
        dataSource.registerReuseIdentifiers(to: collectionView)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        
        self.dataSource = dataSource
        return dataSource
    }
    
    public func reloadDataAndUI(animated: Bool = false) {
        let oldDataSource = self.dataSource
        let newDataSource = createDataSource()
        
        if let oldDataSource = oldDataSource, animated == true {
            var removed = [IndexPath]()
            var added = [IndexPath]()
            
            for (index, section) in oldDataSource.sections.enumerated() {
                guard newDataSource.sections.count > index else { continue }
                let sectionIDs = section.items.map { $0.identifier }
                let newSectionIDs = newDataSource.sections[index].items.map { $0.identifier }
                
                let diff = sectionIDs.diff(with: newSectionIDs)
                
                let removedIndexes = diff.removed.map { IndexPath(item: sectionIDs.index(of: $0)!, section: index) }
                removed.append(contentsOf: removedIndexes)
                
                let addedIndexes = diff.added.map { IndexPath(item: newSectionIDs.index(of: $0)!, section: index) }
                added.append(contentsOf: addedIndexes)
            }
            
            collectionView?.performBatchUpdates({ 
                self.collectionView?.insertItems(at: added)
                self.collectionView?.deleteItems(at: removed)
            }, completion: nil)
        } else {
            collectionView?.reloadData()
        }
    }
}



open class BlockCollectionViewController: UICollectionViewController, ConfigurableCollection {
    public var dataSource: Grid?
    
    open func configureDataSource(dataSource: Grid) {
        // Base class does nothing
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataAndUI()
    }
}
