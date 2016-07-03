//  The MIT License (MIT)
//
//  Copyright (c) 2016 Adam Cumiskey
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//
//  LCS.swift
//  bestroute
//
//  Created by Adam Cumiskey on 5/1/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import Foundation


private enum Move: String, RawRepresentable {
    case None = "x"
    case Vertical = "|"
    case Horizontal = "-"
    case Diagonal = "\\"
}

private struct Cell: CustomDebugStringConvertible {
    var length: UInt
    var move: Move
    
    var debugDescription: String {
        return "(\(length), \(move.rawValue))"
    }
}

private struct Grid: CustomDebugStringConvertible {
    private var cells = [String: Cell]()
    private var dimensions: (Int, Int) = (0,0)
    
    subscript(row: Int, column: Int) -> Cell {
        get {
            guard let cell = cells[key(row, column)] else {
                return Cell(length: 0, move: .None)
            }
            return cell
        }
        set {
            cells[key(row, column)] = newValue
            dimensions = (max(dimensions.0, row+1), max(dimensions.1, column+1))
        }
    }
    
    private func key(row: Int, _ column: Int) -> String {
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

private func lcs_grid<T where T: Equatable>(a: [T], _ b: [T]) -> Grid {
    var grid = Grid()
    for (i, x) in a.enumerate() {
        for (j, y) in b.enumerate() {
            var cell: Cell
            if x == y {
                cell = Cell(length: grid[i-1,j-1].length + 1, move: .Diagonal)
            } else {
                let horizontal = grid[i-1,j].length
                let vertical = grid[i,j-1].length
                if horizontal < vertical {
                    cell = Cell(length: vertical, move: .Vertical)
                } else {
                    cell = Cell(length: horizontal, move: .Horizontal)
                }
            }
            grid[i,j] = cell
        }
    }
    return grid
}

// Longest common subsequence alogorithm
public func findLCS<T where T: Equatable>(a: [T], _ b: [T]) -> [T] {
    let grid = lcs_grid(a, b)
    var lcs = [T]()
    var i = a.count-1, j = b.count-1
    repeat {
        switch grid[i, j].move {
        case .Vertical:
            j -= 1
            break
        case .Horizontal:
            i -= 1
            break
        case .Diagonal:
            lcs.append(a[i])
            i -= 1; j -= 1
            break
        default:
            break
        }
    
    } while (grid[i, j].move != .None)
    return lcs.reverse()
}

// Return the diff of two arrays as a tuple of (removed, added) where removed and added are dictionaries indexed by row
public func diff<T where T: Equatable>(a: [T], _ b: [T]) -> ([Int: T], [Int: T]) {
    var removed = [Int: T]()
    var added = [Int: T]()
    let lcs = findLCS(a, b)
    // If an item is in the first array, but not the lcs, it was deleted
    for (i, item) in a.enumerate() {
        if lcs.indexOf(item) == nil {
            removed[i] = item
        }
    }
    // If an item is in the second array, but not the lcs, it was added
    for (i, item) in b.enumerate() {
        if lcs.indexOf(item) == nil {
            added[i] = item
        }
    }
    return (removed, added)
}

