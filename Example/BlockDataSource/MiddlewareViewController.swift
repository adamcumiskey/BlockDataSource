//
//  MiddlewareViewController.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 2/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import BlockDataSource

class MiddlewareViewController: UIViewController, ConfigurableTable, Table {
    @IBOutlet weak var table: UITableView!
    var dataSource: List?
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMarginConstraint: NSLayoutConstraint!
    var margin: CGFloat = 0.0 {
        didSet {
            leftMarginConstraint.constant = margin
            rightMarginConstraint.constant = margin
        }
    }
    
    var data = (0..<100).map { "\($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        margin = 15
        view.backgroundColor = table.backgroundColor
        table.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataAndUI()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        self.margin = editing ? 0 : 15
        UIView.animate(
            withDuration: 0.23,
            animations: view.layoutIfNeeded,
            completion: { finished in
                super.setEditing(editing, animated: animated)
                self.table.setEditing(editing, animated: animated)
            }
        )
    }
    
    func configureDataSource(dataSource: List) {
        let cornerMiddleware = Middleware { (cell: RoundCorneredCell, path, structure) in
            cell.cornerRadius = 15.0
            if structure[path.section].rows.count == 1 {
                cell.position = .single
            } else if path.row == 0 {
                cell.position = .top
            } else if path.row == structure[path.section].rows.count-1 {
                cell.position = .bottom
            } else {
                cell.position = .middle
            }
        }
        let colorMiddleware = Middleware { [unowned self] (cell: RoundCorneredCell, path, structure) in
            let hue = CGFloat(path.row)/CGFloat(self.data.count)
            let color = UIColor(
                hue: hue,
                saturation: 1.0,
                brightness: 1.0,
                alpha: 1.0
            )
            cell.customSeparatorColor = color
        }
        dataSource.middlewareStack = [cornerMiddleware, colorMiddleware]
        dataSource.sections = [
            List.Section(
                rows: data.map { n in
                    return List.Row(
                        configure: { (cell: RoundCorneredCell) in
                            cell.textLabel?.text = n
                        },
                        onDelete: { [unowned self] indexPath in
                            self.data.remove(at: indexPath.row)
                        },
                        reorderable: true,
                        shouldIndentWhileEditing: false
                    )
                }
            )
        ]
        dataSource.onReorder = { [unowned self] _, _ in
            self.table.reloadData()
        }
    }
    
}
