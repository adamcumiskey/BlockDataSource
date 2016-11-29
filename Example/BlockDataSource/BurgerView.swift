//
//  BurgerView.swift
//  BlockDataSource
//
//  Created by Adam Cumiskey on 11/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit


class BurgerView: UIView {
    
}


public extension UIView {
    public class func fromNib(_ nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil, type: self)
    }
    
    public class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v: T? = fromNib(nibNameOrNil, type: T.self)
        return v!
    }
    
    public class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        if let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil) {
            for v in nibViews {
                if let tog = v as? T {
                    view = tog
                }
            }
        }
        return view
    }
    
    public class var nibName: String {
        return String(describing: self)
    }
    public class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
}
