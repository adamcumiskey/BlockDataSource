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
//  AppDelegate.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 06/29/2016.
//  Copyright (c) 2016 Adam Cumiskey. All rights reserved.
//

import UIKit
import BlockDataSource

let noCellSelectionStyle = Middleware { (view: UITableViewCell, _: IndexPath, _: [Section]) in
    view.selectionStyle = .none
}

let cellGradient = Middleware { (view: UITableViewCell, indexPath: IndexPath, sections: [Section]) in
    let normalized = CGFloat(Double(indexPath.row) / Double(sections[indexPath.section].items.count))
    let backgroundColor = UIColor(white: 1-normalized, alpha: 1.0)
    let textColor = UIColor(white: normalized, alpha: 1.0)
    view.contentView.backgroundColor = backgroundColor
    view.textLabel?.textColor = textColor
    view.detailTextLabel?.textColor = textColor
}

let noTableSeparator = Middleware { (view: UITableView, _, _) in
    view.separatorStyle = .none
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)

            let mainMenuDataSource = DataSource(
                sections: [
                    Section(
                        items: (0..<50).map { _ in
                            return Item { (cell: UITableViewCell) in
                                cell.textLabel?.text = "Hi"
                            }
                        }
                    )
                ],
                middleware: [noCellSelectionStyle, cellGradient, noTableSeparator]
            )

            let mainVC = BlockTableViewController(
                style: .plain,
                dataSource: mainMenuDataSource
            )
            let navVC = UINavigationController(rootViewController: mainVC)

            window!.rootViewController = navVC
            window!.makeKeyAndVisible()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
