//
//  CollectionExampleViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 11/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import BlockDataSource


class CollectionExampleViewController: BlockCollectionViewController {
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = (0..<100).flatMap { n in
            if n % 2 == 0 {
                return UIImage(named: "king_burger")
            } else {
                return UIImage(named: "lego_burger")
            }
        }
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 200)
            layout.itemSize = CGSize(width: 100, height: 100)
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
    }
    
    override func configureDataSource(dataSource: CollectionData) {
        dataSource.sections.append(
            CollectionData.Section(
                header: CollectionData.Section.HeaderFooter { (view: ImageReusableView) in
                    view.imageView.image = UIImage(named: "double_burger")
                },
                items: images.map { image in
                    return CollectionData.Item(reorderable: true) { (cell: ImageCollectionViewCell) in
                        cell.imageView.image = image
                    }
                }
            )
        )
        dataSource.onReorder = { [unowned self] source, destination in
            self.images.moveObjectAtIndex(source.row, toIndex: destination.row)
        }
    }
}
