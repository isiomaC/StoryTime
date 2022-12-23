//
//  Utils.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit

struct Utils {
    static func readFromPList(_ filename: String, key: String) -> String{
        guard let filePath = Bundle.main.path(forResource: filename, ofType: "plist") else {
          fatalError("Couldn't find file '\(filename).plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
          fatalError("Couldn't find key '\(key)' in '\(filename).plist'.")
        }
        return value
    }
    
    static func attributedText(_ string: String, targetString: String, font: UIFont) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        
//        attributedString.removeAttribute(<#T##name: NSAttributedString.Key##NSAttributedString.Key#>, range: <#T##NSRange#>)
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        
        let underlineAttribute = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue
        ]
        
        let colorAttributed = [
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        
        let range = (string as NSString).range(of: targetString)
        
        attributedString.addAttributes(underlineAttribute, range: range)
        attributedString.addAttributes(boldFontAttribute, range: range)
        
        attributedString.addAttributes(colorAttributed, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
}
