//
//  Vines.swift
//  BlockDataSource_Example
//
//  Created by Adam on 6/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Vine

extension Vine {
    class var root: Vine<Window> {
        return Vine<Window> { vine in
            let controller = NavigationController(vine: MenuVine())
        }
    }
}
