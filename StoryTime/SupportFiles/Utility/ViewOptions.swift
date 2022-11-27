//
//  ViewOptions.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.


import Foundation
import UIKit


struct LabelOptions {
    let text: String
    let color: UIColor
    let fontStyle: UIFont?
    
    init(text: String, color: UIColor = .white, fontStyle: UIFont) {
        self.text = text
        self.color = color
        self.fontStyle = fontStyle
    }
}

struct ButtonOptions {
    let title: String
    let color: UIColor
    let image: UIImage?
    let smiley: String?
    let borderWidth: CGFloat
    let radius: CGFloat
    let font: UIFont
    let titleColor: UIColor
    
    init(title: String, color: UIColor,
         borderWidth: CGFloat = 1.0, radius: CGFloat = 22,
         font: UIFont = Font(type: .custom("HelveticaNeue-Medium"), size: .custom(18)).instance,
         image: UIImage?, smiley: String?, titleColor: UIColor = .white) {
        self.title = title
        self.color = color
        self.borderWidth = borderWidth
        self.radius = radius
        self.font = font
        self.image = image
        self.smiley = smiley
        self.titleColor = titleColor
    }
}

struct TextFieldOptions {
    let backgroundColor: UIColor
    let placeholder: String
    let alignment: NSTextAlignment
    let textColor: UIColor
    let fontStyle: UIFont?
    let keyboardType: UIKeyboardType
    let secured: Bool
    
    init( placeholder: String, textColor: UIColor = .lightGray,
          fontStyle: UIFont, alignment: NSTextAlignment = .left,
          keyboardType: UIKeyboardType = .default, backgroundColor: UIColor = .clear,
          secured: TextFieldType = .normal ) {
        
        self.secured =  secured == .secured ? true : false
        self.backgroundColor = backgroundColor
        self.placeholder = placeholder
        self.alignment = alignment
        self.textColor = textColor
        self.fontStyle = fontStyle
        self.keyboardType = keyboardType
    }
}

struct ViewOptions {
    let backgroundColor: UIColor
}

struct ImageViewOptions {
    let image: UIImage?
    let size: (width: CGFloat, height: CGFloat)?
    
    init(image: UIImage?, size: (width: CGFloat, height: CGFloat)?) {
        
//        if let img = image, let mSize = size {
        self.image = image
        self.size = size
//        } else {
//            self.image = nil
//            self.size = nil
//        }
    }
}

struct TextViewOptions {
    let backgroundColor: UIColor
    let placeholder: String
    let alignment: NSTextAlignment?
    let textColor: UIColor
    let fontStyle: UIFont?
    
    init(backgroundColor: UIColor, placeholder: String, alignment: NSTextAlignment = .natural, textColor: UIColor, fontStyle: UIFont) {
        self.backgroundColor = backgroundColor
        self.placeholder = placeholder
        self.alignment = alignment
        self.textColor = textColor
        self.fontStyle = fontStyle
    }
}

//
//struct ImageViewOptions{
//    let image : UIImage?
//    
//    init(image: UIImage?) {
//        
//        if let img = image{
//            self.image = img
//        }else{
//            self.image = nil
//        }
//        
//    }
//}
