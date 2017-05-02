//
//  ListDataSource.swift
//  Pods
//
//  Created by Adam Cumiskey on 5/2/17.
//
//

import Foundation


// MARK: -
/// UITableView delegate and dataSource with block-based constructors
public class ListDataSource: NSObject, DataSource {
    public typealias ViewType = List

    /// The section data for the table view
    public var sections = [Section<ViewType>]()

    /// Callback for when a item is reordered
    public var onReorder: ReorderBlock?

    /// Callback for the UIScrollViewDelegate
    public var onScroll: ScrollBlock?

    /// Cell configuration middleware.
    /// Gets applied in DataSource order to cells matching the middleware cellClass type
    public var middleware: [ViewType.Middleware]

    /**
     Initialize a DataSource

     - parameters:
     - sections: The array of sections in this DataSource
     - onReorder: Optional callback for when items are moved. You should update the order your underlying data in this callback. If this property is `nil`, reordering will be disabled for this TableView
     - onScroll: Optional callback for recieving scroll events from UIScrollViewDelegate
     */
    public init(sections: [Section<ViewType>], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil, middleware: [ViewType.Middleware] = []) {
        self.sections = sections
        self.onReorder = onReorder
        self.onScroll = onScroll
        self.middleware = middleware
    }

    public convenience override init() {
        self.init(items: [])
    }

    /// Convenience init for a DataSource with a single section
    public convenience init(section: Section<ViewType>, onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [section],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }

    /// Convenience init for a DataSource with a single section with no headers/footers
    public convenience init(items: [ViewType.Item], onReorder: ReorderBlock? = nil, onScroll: ScrollBlock? = nil) {
        self.init(
            sections: [Section<ViewType>(items: items)],
            onReorder: onReorder,
            onScroll: onScroll
        )
    }

}


// MARK: - UITableViewDataSource

extension ListDataSource: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self[indexPath]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
        // resonable default. can be overriden in configure block
        cell.selectionStyle = (item.onSelect != nil) ? UITableViewCellSelectionStyle.`default` : UITableViewCellSelectionStyle.none
        item.configure(cell)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension ListDataSource: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        for middleware in middleware {
            middleware.apply(cell)
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onSelect = self[indexPath].onSelect {
            onSelect(indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self[section].header else { return nil }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.reuseIdentifier) else { return nil }
        header.configure(view)
        return view
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let header = self[section].footer else { return nil }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.reuseIdentifier) else { return nil }
        header.configure(view)
        return view
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let header = self.tableView(tableView, viewForHeaderInSection: section) {
            return header.frame.height
        } else {
            return UITableViewAutomaticDimension
        }
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footer = self.tableView(tableView, viewForFooterInSection: section) {
            return footer.frame.height
        } else {
            return UITableViewAutomaticDimension
        }
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let item = self[indexPath]
        return item.onDelete != nil || item.reorderable == true
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard let _ = self[indexPath].onDelete else { return .none }
        return .delete
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let onDelete = self[indexPath].onDelete {
                sections[indexPath.section].items.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                onDelete(indexPath)
            }
        }
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self[indexPath].reorderable
    }

    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return self[proposedDestinationIndexPath].reorderable ? proposedDestinationIndexPath : sourceIndexPath
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let reorder = onReorder {
            if sourceIndexPath.section == destinationIndexPath.section {
                sections[sourceIndexPath.section].items.moveObjectAtIndex(sourceIndexPath.item, toIndex: destinationIndexPath.item)
            } else {
                let item = sections[sourceIndexPath.section].items.remove(at: sourceIndexPath.item)
                sections[destinationIndexPath.section].items.insert(item, at: destinationIndexPath.item)
            }
            reorder(sourceIndexPath, destinationIndexPath)
        }
    }
}


// MARK: - UIScrollViewDelegate

extension ListDataSource: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let onScroll = onScroll {
            onScroll(scrollView)
        }
    }
}


// MARK: - Cell Registration

public extension UITableView {
    public func registerReuseIdentifiers(forDataSource dataSource: ListDataSource) {
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

    private func register(sectionDecoration: ListSectionDecoration) {
        if let _ = Bundle.main.path(forResource: sectionDecoration.reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: sectionDecoration.reuseIdentifier, bundle: nil)
            register(nib, forHeaderFooterViewReuseIdentifier: sectionDecoration.reuseIdentifier)
        } else {
            register(sectionDecoration.viewClass, forHeaderFooterViewReuseIdentifier: sectionDecoration.reuseIdentifier)
        }
    }
}
