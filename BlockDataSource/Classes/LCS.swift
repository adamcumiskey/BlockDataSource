//
//  LCS.swift
//
//  Created by Adam Cumiskey on 5/1/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//
// Find the longest common subsequence in two arrays

import Foundation


private enum Move: String, RawRepresentable {
    case none = "x"
    case vertical = "|"
    case horizontal = "-"
    case diagonal = "\\"
}

private struct Cell: CustomDebugStringConvertible {
    var length: UInt
    var move: Move
    
    var debugDescription: String {
        return "(\(length), \(move.rawValue))"
    }
}

private struct Grid: CustomDebugStringConvertible {
    fileprivate var cells = [String: Cell]()
    fileprivate var dimensions: (Int, Int) = (0,0)
    
    subscript(row: Int, column: Int) -> Cell {
        get {
            guard let cell = cells[key(row, column)] else {
                return Cell(length: 0, move: .none)
            }
            return cell
        }
        set {
            cells[key(row, column)] = newValue
            dimensions = (max(dimensions.0, row+1), max(dimensions.1, column+1))
        }
    }
    
    fileprivate func key(_ row: Int, _ column: Int) -> String {
        return "\(row), \(column)"
    }
    
    var debugDescription: String {
        var string = ""
        for rowIndex in 0..<dimensions.1 {
            for columnIndex in 0..<dimensions.0 {
                string += "\(self[columnIndex, rowIndex])" + "\t"
            }
            string += "\n"
        }
        return string
    }
}

private func lcsGrid<T>(_ a: [T], _ b: [T]) -> Grid where T: Equatable {
    var grid = Grid()
    for (i, x) in a.enumerated() {
        for (j, y) in b.enumerated() {
            var cell: Cell
            if x == y {
                cell = Cell(length: grid[i-1,j-1].length + 1, move: .diagonal)
            } else {
                let horizontal = grid[i-1,j].length
                let vertical = grid[i,j-1].length
                if horizontal < vertical {
                    cell = Cell(length: vertical, move: .vertical)
                } else {
                    cell = Cell(length: horizontal, move: .horizontal)
                }
            }
            grid[i,j] = cell
        }
    }
    return grid
}

// Longest common subsequence alogorithm
public func findLCS<T>(_ a: [T], _ b: [T]) -> [T] where T: Equatable {
    let grid = lcsGrid(a, b)
    var lcs = [T]()
    var i = a.count-1, j = b.count-1
    repeat {
        switch grid[i, j].move {
        case .vertical:
            j -= 1
        case .horizontal:
            i -= 1
        case .diagonal:
            lcs.append(a[i])
            i -= 1; j -= 1
        default: break
        }
        
    } while (grid[i, j].move != .none)
    return lcs.reversed()
}

// Return the diff of two arrays as a tuple of (added, removed)
public func getDiff<T>(_ a: [T], _ b: [T]) -> (added: [T], removed: [T]) where T: Equatable {
    var added = [T]()
    var removed = [T]()
    let lcs = findLCS(a, b)

    // If an item is in the second array, but not the lcs, it was added
    for item in b {
        if lcs.index(of: item) == nil {
            added.append(item)
        }
    }
    
    // If an item is in the first array, but not the lcs, it was deleted
    for item in a {
        if lcs.index(of: item) == nil {
            removed.append(item)
        }
    }
    
    return (added, removed)
}
