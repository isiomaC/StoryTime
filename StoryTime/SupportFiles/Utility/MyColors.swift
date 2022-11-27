//
//  MyColors.swift
//  StoryTime
//
//  Created by Chuck on 25/11/2022.
//

import Foundation
import UIKit

struct MyColors{
    
    // TODO: Set Primary color
    static let primary: UIColor = MyColors.hexStringToUIColor(hex: "48A4FA")
    static let secondary: UIColor = MyColors.hexStringToUIColor(hex: "48A4FA")
    static let background: UIColor = MyColors.hexStringToUIColor(hex: "48A4FA")

    
    // MARK: Gradient Color
    static let topGradient = MyColors.hexStringToUIColor(hex: "48A4FA") //48A4FA
    static let bottomGradient = MyColors.hexStringToUIColor(hex: "006fd1") //006fd1
    
    static func setGradientBackground(view: UIView, top: UIColor, bottom: UIColor) {
        let colorTop =  top.cgColor
        let colorBottom = bottom.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        
        let countlayers = view.layer.sublayers?.count
        
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    static func hexStringToUIColor (hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
