//
//  Font.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//

import Foundation
import UIKit

struct Font {
    enum FontName: String {
        case robotoBlack            = "Roboto-Black"
        case robotoBlackItalic      = "Roboto-BlackItalic"
        case robotoBold             = "Roboto-Bold"
        case robotoBoldItalic       = "Roboto-BoldItalic"
        case robotoItalic           = "Roboto-Italic"
        case robotoLight            = "Roboto_Light"
        case robotoLightItalic      = "Roboto-LightItalic"
        case robotoMedium           = "Roboto-Medium"
        case robotoMediumItalic     = "Roboto-MediumItalic"
        case robotoRegular          = "Roboto-Regular"
        case robotoThin             = "Roboto-Thin"
        case robotoThinItalic       = "Roboto-ThinItalic"
    }
    
    enum CustomFontName: String {
        case heleveticMedium = "HelveticaNeue-Medium"
    }
    
    enum StandardSize: Double {
        case h1 = 20.0
        case h2 = 18.0
        case h3 = 16.0
        case h4 = 14.0
        case h5 = 12.0
        case h6 = 10.0
    }
    
    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
        case monoSpacedDigit(size: Double, weight: Double)
    }
    
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    var type: FontType
    var size: FontSize
    
    init(type: FontType = .custom("HelveticaNeue-Medium"), size: FontSize = .custom(17)) {
        self.type = type
        self.size = size
    }
    
    var instance: UIFont {
        var fontToReturn: UIFont!
        switch type {
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it is added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            fontToReturn = font
                
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it is added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            fontToReturn = font
                
        case .system:
            fontToReturn = UIFont.systemFont(ofSize: CGFloat(size.value))
                
        case .systemBold:
            fontToReturn = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
                
        case .systemItatic:
            fontToReturn = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
                
        case .systemWeighted(weight: let weight):
            fontToReturn = UIFont.systemFont(ofSize: CGFloat(size.value),
                                                 weight: UIFont.Weight.init(rawValue: CGFloat(weight)))
                
        case .monoSpacedDigit(size: let size, weight: let weight):
            fontToReturn = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size),
                                                                            weight: UIFont.Weight.init(rawValue: CGFloat(weight)))
        }
        return fontToReturn
    }
}
