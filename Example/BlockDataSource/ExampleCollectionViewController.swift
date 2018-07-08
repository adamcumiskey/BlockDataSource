//
//  ExampleCollectionViewController.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BlockDataSource
import UIKit

class ExampleCollectionViewController: BlockCollectionViewController {
    lazy var items: [UIImage] = {
        return (0..<30).map { _ in
            let rand = arc4random_uniform(100)
            if rand % 2 == 0 {
                return #imageLiteral(resourceName: "king_burger")
            } else {
                return #imageLiteral(resourceName: "lego_burger")
            }
        }
    }()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = .init(width: UIScreen.main.bounds.width, height: 100)
        
        super.init(collectionViewLayout: layout)
        
        self.title = "Reordering"
        self.collectionView?.backgroundColor = .white
        
        self.dataSource = DataSource(
            sections: [
                Section(
                    header: Reusable { (view: InformationCollectionReusableView) in
                        view.textLabel?.text = "Press and hold on a cell for a few moments, then drag and drop to reorder."
                    },
                    items: items.map { item in
                        return Item(reorderable: true) { (cell: ImageCollectionViewCell) in
                            cell.imageView.image = item
                        }
                    }
                )
            ],
            onReorder: { [unowned self] origin, destination in
                self.items.moveObjectAtIndex(origin.item, toIndex: destination.item)
            }
        )
    }
}
