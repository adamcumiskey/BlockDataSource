//
//  Extentions.swift
//  Pods
//
//  Created by Adam Cumiskey on 12/15/16.
//
//

import Foundation


extension Array {
    mutating func moveObjectAtIndex(_ index: Int, toIndex: Int) {
        let element = self[index]
        remove(at: index)
        insert(element, at: toIndex)
    }
}


// MARK: - Table Cell Registration

public extension UITableView {
    public func registerReuseIdentifiers(forDataSource dataSource: DataSource) {
        for section in dataSource.sections {
            if let header = section.header {
                register(sectionDecoration: header)
            }
            for item in section.items {
                if let _ = Bundle.main.path(forResource: item.reuseIdentifier, ofType: "nib") {
                    let nib = UINib(nibName: item.reuseIdentifier, bundle: Bundle.main)
                    register(nib, forCellReuseIdentifier: item.reuseIdentifier)
                } else {
                    register(item.viewClass, forCellReuseIdentifier: item.reuseIdentifier)
                }
            }
            if let footer = section.footer {
                register(sectionDecoration: footer)
            }
        }
    }

    private func register(sectionDecoration: Reusable) {
        if let _ = Bundle.main.path(forResource: sectionDecoration.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: sectionDecoration.reuseIdentifier, bundle: nil)
            register(nib, forHeaderFooterViewReuseIdentifier: sectionDecoration.reuseIdentifier)
        } else {
            register(sectionDecoration.viewClass, forHeaderFooterViewReuseIdentifier: sectionDecoration.reuseIdentifier)
        }
    }
}


// MARK: - Cell Registration

public extension UICollectionView {
    public func registerReuseIdentifiers(forDataSource dataSource: DataSource) {
        for section in dataSource.sections {
            if let header = section.header {
                register(sectionDecoration: header, kind: UICollectionElementKindSectionHeader)
            }
            for item in section.items {
                register(item: item)
            }
            if let footer = section.footer {
                register(sectionDecoration: footer, kind: UICollectionElementKindSectionFooter)
            }
        }
    }

    private func register(sectionDecoration: Reusable, kind: String) {
        if let _ = Bundle.main.path(forResource: sectionDecoration.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: sectionDecoration.reuseIdentifier, bundle: nil)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: sectionDecoration.reuseIdentifier)
        } else {
            register(sectionDecoration.viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: sectionDecoration.reuseIdentifier)
        }
    }

    private func register(item: Item) {
        if let _ = Bundle.main.path(forResource: item.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: item.reuseIdentifier, bundle: Bundle.main)
            register(nib, forCellWithReuseIdentifier: item.reuseIdentifier)
        } else {
            register(item.viewClass, forCellWithReuseIdentifier: item.reuseIdentifier)
        }
    }
}
