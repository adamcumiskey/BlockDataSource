//
//  ButtonTableViewCell.swift
//  bestroute
//
//  Created by Adam Cumiskey on 6/24/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    var buttonAction: ((button: UIButton) -> Void)?
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonPressed(sender: AnyObject) {
        if let buttonAction = self.buttonAction {
            buttonAction(button: sender as! UIButton)
        }
    }
}
