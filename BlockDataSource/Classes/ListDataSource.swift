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
public class ListDataSource: DataSource<List>, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self[indexPath]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        return cell
    }


    // MARK: - UITableViewDelegate

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
