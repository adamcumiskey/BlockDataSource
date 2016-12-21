//
//  AnimatedGridViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 12/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import BlockDataSource


class AnimatedGridViewController: BlockCollectionViewController {
    
    let dataset1 = (2..<9).map { DataItem(title: "\($0)") }
    let dataset2 = (0..<4).map { DataItem(title: "\($0)") }

    var toggle: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 100, height: 100)
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Toggle", style: .plain, target: self, action: #selector(toggleDataSource))
    }
    
    func toggleDataSource() {
        toggle = !toggle
        reloadDataAndUI(animated: true)
    }
    
    override func configureDataSource(dataSource: Grid) {
        let dataSet = toggle ? dataset1 : dataset2
        dataSource.sections.append(
            Grid.Section(
                items: dataSet.map { dataItem in
                    return Grid.Item(identifier: dataItem.title) { (cell: LabelCollectionViewCell) in
                        cell.label.text = dataItem.title
                        cell.backgroundColor = .white
                    }
                }
            )
        )
    }
    
}
