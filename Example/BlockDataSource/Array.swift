//
//  Array.swift
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
