//
//  GridDataSource.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import Foundation


public class GridDataSource: NSObject, DataSource {
    public typealias Item = GridItem

    /// The section data for the table view
    public var sections = [Section<Item>]()

    /// Callback for when a item is reordered
    public var onReorder: ReorderBlock?

    /// Callback for the UIScrollViewDelegate
    public var onScroll: ScrollBlock?

    /// Cell configuration middleware.
    /// Gets applied in DataSource order to cells matching the middleware cellClass type
    public var middleware: [Item.MiddlewareType]

    /**
     Initialize a DataSource

     - parameters:
     - sections: The array of sections in this DataSource
     - onReorder: Optional callback for when items are moved. You should update the order your underlying data in this callback. If this property is `nil`, reordering will be disabled for this TableView
     - onScroll: Optional callback for recieving scroll events from UIScrollViewDelegate
     */
    public init(sections: [Section<Item>], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil, middleware: [Item.MiddlewareType] = []) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
        self.middleware = middleware
    }

    public convenience override init() {
        self.init(items: [])
    }

    /// Convenience init for a DataSource with a single section
    public convenience init(section: Section<Item>, onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [section],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }

    /// Convenience init for a DataSource with a single section with no headers/footers
    public convenience init(items: [Item], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [Section<Item>(items: items)],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }
}


// MARK: - UICollectionViewDataSource

extension GridDataSource: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection sectionIndex: Int) -> Int {
        return self[sectionIndex].items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        return cell
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        guard onReorder != nil else { return false }
        return self[indexPath].reorderable
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let reorder = onReorder {
            // Reorder the items
            if sourceIndexPath.section == destinationIndexPath.section {
                sections[sourceIndexPath.section].items.moveObjectAtIndex(sourceIndexPath.item, toIndex: destinationIndexPath.item)
            } else {
                let item = sections[sourceIndexPath.section].items.remove(at: sourceIndexPath.item)
                sections[destinationIndexPath.section].items.insert(item, at: destinationIndexPath.item)
            }
            // Update data model in this callback
            reorder(sourceIndexPath, destinationIndexPath)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self[indexPath.section]
        if kind == UICollectionElementKindSectionHeader {
            guard let header = section.header else { return UICollectionReusableView() }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header.reuseIdentifier, for: indexPath)
            header.configure(view)
            return view
        } else if kind == UICollectionElementKindSectionFooter {
            guard let footer = section.footer else { return UICollectionReusableView() }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footer.reuseIdentifier, for: indexPath)
            footer.configure(view)
            return view
        }
        return UICollectionReusableView()
    }
}


// MARK: - UICollectionViewDelegate

extension GridDataSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        for middleware in middleware {
            middleware.apply(cell)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return self[indexPath].onSelect != nil
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let onSelect = self[indexPath].onSelect {
            onSelect(indexPath)
        }
    }
}


// MARK: - Cell Registration

public extension UICollectionView {
    public func registerReuseIdentifiers(forDataSource dataSource: GridDataSource) {
        for section in dataSource.sections {
            if let header = section.header {
                register(headerFooter: header, kind: UICollectionElementKindSectionHeader)
            }
            for item in section.items {
                register(item: item)
            }
            if let footer = section.footer {
                register(headerFooter: footer, kind: UICollectionElementKindSectionFooter)
            }
        }
    }

    private func register(headerFooter: GridHeader, kind: String) {
        if let _ = Bundle.main.path(forResource: headerFooter.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: headerFooter.reuseIdentifier, bundle: nil)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: headerFooter.reuseIdentifier)
        } else {
            register(headerFooter.viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: headerFooter.reuseIdentifier)
        }
    }

    private func register(item: GridItem) {
        if let _ = Bundle.main.path(forResource: item.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: item.reuseIdentifier, bundle: Bundle.main)
            register(nib, forCellWithReuseIdentifier: item.reuseIdentifier)
        } else {
            register(item.viewClass, forCellWithReuseIdentifier: item.reuseIdentifier)
        }
    }
}
