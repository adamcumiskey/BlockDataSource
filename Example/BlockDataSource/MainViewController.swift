//
//  MainViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 11/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import BlockDataSource


class MainViewController: BlockTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = BlockDataSource(
            sections: [
                Section(
                    rows: [
                        Row(
                            configure: { cell in
                                cell.textLabel?.text = "Examples"
                            },
                            onSelect: { [unowned self] indexPath in
                                let testVC = CellExamplesViewController(style: .grouped)
                                testVC.title = "Examples"
                                self.navigationController?.pushViewController(testVC, animated: true)
                            }
                        ),
                        Row(
                            configure: { cell in
                                cell.textLabel?.text = "Editing"
                            },
                            onSelect: { [unowned self] indexPath in
                                let reorderVC = EditingViewController(style: .grouped)
                                reorderVC.title = "Editing"
                                self.navigationController?.pushViewController(reorderVC, animated: true)
                            }
                        ),
//                        Row(
//                            configure: { cell in
//                                
//                            }
//                        ),
//                        Row(
//                            configure: { cell in
//                                
//                            }
//                        ),
//                        Row(
//                            configure: { cell in
//                                
//                            }
//                        ),
                    ]
                )
            ]
        )
    }
}
