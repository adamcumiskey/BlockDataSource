//  Copyright (c) 2018 Adam <adam.cumiskey@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Vine.swift
//  Vine
//
//  Created by Adam on 6/16/18.
//  Copyright © 2018 Adam Cumiskey. All rights reserved.
//

import UIKit

public protocol VineType: class {
    /// Attach to root
    func start()
}

/** A Vine attached to a root.
 
 For convenience, this class can be initialized with a block that will be called
 on `start()`. Subclasses can override the start method implement setup logic internally.
 
 While this library focuses on UIKit, Vine is really just a pattern for creating parent-child
 relationships where the parent starts and retains the child while the child delegates actions
 back up to the parent. You can attach a Vine to any kind of object you want.
*/
open class Vine<Root: AnyObject>: VineType {
    public typealias StartFunction = ((Vine<Root>) -> Void)

    public weak var root: Root?
    private var startFunction: StartFunction?

    public init(start: StartFunction? = nil) {
        self.startFunction = start
    }

    open func start() {
        startFunction?(self)
    }
}

// MARK: - Window

public class Window: UIWindow {
    /// Reference to the Vine
    var vine: Vine<Window>

    public init(frame: CGRect, vine: Vine<Window>) {
        self.vine = vine
        super.init(frame: frame)
        self.vine.root = self
        self.vine.start()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - NavigationController

// The initializers for this are a little fucked up at the moment.
public class NavigationController: UINavigationController {
    public typealias VineType = Vine<NavigationController>
    var vine: VineType?

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public init(vine: VineType, navigationBarClass: AnyClass? = nil, toolbarClass: AnyClass? = nil) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.vine = vine
        self.vine?.root = self
        self.vine?.start()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SplitViewController

public class SplitViewController: UISplitViewController {
    public typealias VineType = Vine<SplitViewController>
    var vine: VineType

    public init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, vine: VineType) {
        self.vine = vine
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.vine.root = self
        self.vine.start()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - TabBarController

public class TabBarController: UITabBarController {
    public typealias VineType = Vine<TabBarController>
    var vine: VineType

    public init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, vine: VineType) {
        self.vine = vine
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.vine.root = self
        self.vine.start()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
