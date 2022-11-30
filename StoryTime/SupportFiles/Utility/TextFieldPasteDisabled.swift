//
//  TextFieldPasteDisabled.swift
//  StoryTime
//
//  Created by Chuck on 25/11/2022.
//

import Foundation
import UIKit

class TextFieldPasteDisabled: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
