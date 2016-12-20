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

private struct LCSGrid: CustomDebugStringConvertible {
    fileprivate var cells = [String: Cell]()
    fileprivate var dimensions: (Int, Int) = (0,0)
    
    init<T>(_ a: [T], _ b: [T]) where T: Equatable {
        for (i, x) in a.enumerated() {
            for (j, y) in b.enumerated() {
                var cell: Cell
                if x == y {
                    cell = Cell(length: self[i-1,j-1].length + 1, move: .diagonal)
                } else {
                    let horizontal = self[i-1,j].length
                    let vertical = self[i,j-1].length
                    if horizontal < vertical {
                        cell = Cell(length: vertical, move: .vertical)
                    } else {
                        cell = Cell(length: horizontal, move: .horizontal)
                    }
                }
                self[i,j] = cell
            }
        }
    }
    
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

// Longest common subsequence alogorithm
public func findLCS<T>(_ a: [T], _ b: [T]) -> [T] where T: Equatable {
    let grid = LCSGrid(a, b)
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

extension Array where Element: Equatable {
    func diff(with array: [Element]) -> (added: [Element], removed: [Element]) {
        var added = [Element]()
        var removed = [Element]()
        let lcs = findLCS(self, array)
        
        // If an item is in the second array, but not the lcs, it was added
        for item in array {
            if lcs.index(of: item) == nil {
                added.append(item)
            }
        }
        
        // If an item is in the first array, but not the lcs, it was deleted
        for item in self {
            if lcs.index(of: item) == nil {
                removed.append(item)
            }
        }
        
        return (added, removed)
    }
}
