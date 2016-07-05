//
//  TextFieldCell.swift
//  bestroute
//
//  Created by Adam Cumiskey on 6/25/15.
//  Copyright (c) 2015 adamcumiskey. All rights reserved.
//

import UIKit


enum TextFieldCellStyle {
    case Default
    case Email
    case Password
    case Number
}


class TextFieldCell: UITableViewCell, UITextFieldDelegate {
    
    var shouldBeginEditing: ((textField: UITextField) -> Bool)?
    var didBeginEditing: ((textField: UITextField) -> Void)?
    var shouldEndEditing: ((textField: UITextField) -> Bool)?
    var didEndEditing: ((textField: UITextField) -> Void)?
    
    var shouldChangeCharactersInRange: ((textField: UITextField, range: NSRange, replacementString: String) -> Bool)?
    var didChange: ((text: String) -> Void)?
    var shouldClear: ((textField: UITextField) -> Bool)?
    var shouldReturn: ((textField: UITextField) -> Bool)?
    
    @IBOutlet weak var textField: UITextField!
    var style: TextFieldCellStyle = .Default {
        didSet {
            switch style {
            case .Default:
                textField.secureTextEntry = false
                textField.clearButtonMode = .WhileEditing
                break
            case .Email:
                textField.autocapitalizationType = .None
                textField.autocorrectionType = .No
                textField.keyboardType = .EmailAddress
                textField.clearButtonMode = .WhileEditing
                break
            case .Password:
                textField.secureTextEntry = true
                textField.clearButtonMode = .WhileEditing
                break
            case .Number:
                textField.keyboardType = .NumberPad
                textField.clearButtonMode = .WhileEditing
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.clearButtonMode = .Always
        self.style = .Default
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let shouldBeginEditing = self.shouldBeginEditing {
            return shouldBeginEditing(textField: textField)
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if let didBeginEditing = self.didBeginEditing {
            didBeginEditing(textField: textField)
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if let shouldEndEditing = self.shouldEndEditing {
            return shouldEndEditing(textField: textField)
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let didEndEditing = self.didEndEditing {
            didEndEditing(textField: textField)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text ?? "").stringByReplacingCharactersInRange(range, withString: string)
        
        if let shouldChangeCharactersInRange = self.shouldChangeCharactersInRange {
            let shouldChange = shouldChangeCharactersInRange(textField: textField, range: range, replacementString: string)
            if let textFieldDidChange = self.didChange where shouldChange == true {
                textFieldDidChange(text: newString)
            }
            return shouldChange
        }
        if let textFieldDidChange = self.didChange {
            textFieldDidChange(text: newString)
        }
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        if let shouldClear = self.shouldClear {
            return shouldClear(textField: textField)
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let shouldReturn = self.shouldReturn {
            return shouldReturn(textField: textField)
        }
        textField.resignFirstResponder()
        return true
    }
    
}
